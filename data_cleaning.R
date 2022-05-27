#data sort file

data=read.csv("occurrence.csv")
library(dplyr)
data=data[data$taxonRank=="SPECIES"|data$taxonRank=="SUBSPECIES"|data$taxonRank=="VARIETY",]
data2=data[!data$stateProvince=="",]
data2=data2[!data2$specificEpithet=="",]
data2 %>% group_by(county) %>% summarize(sample=n())
county.clean=data2[!(data2$county==""),]
library(stringr)
county.clean2= county.clean %>% mutate(county.cleaned = county %>% str_to_title())
county.clean3 <- county.clean2 %>% mutate(county.cleaned1 = gsub("[()]", "", county.cleaned))
county.clean3 <- county.clean3 %>% mutate(county.cleaned1 = gsub("\\[|\\]", "", county.cleaned1))
county.clean3 <- county.clean3 %>% mutate(county.cleaned1 = gsub("County", "", county.cleaned1))
county.clean3 <- county.clean3 %>% mutate(county.cleaned1 = gsub("Co.", "", county.cleaned1))
county.clean3 <- county.clean3 %>% mutate(county.cleaned1 = gsub("\\/.*", "", county.cleaned1))
county.clean3 <- county.clean3 %>% mutate(county.cleaned1 = gsub(" Or.*", "", county.cleaned1))
county.clean3$county.cleaned2 <- trimws(county.clean3$county.cleaned1, which = c("both"))
county.clean4=county.clean3[!(county.clean3$county.cleaned2==""),]
county.clean4 %>% group_by(stateProvince) %>% dplyr::summarize(sample=n())
county.clean4 = county.clean4[!is.na(county.clean4$year),]
county.clean4 = county.clean4[!is.na(county.clean4$startDayOfYear),]


states=county.clean4 %>% group_by(stateProvince, specificEpithet) %>% 
  summarize(sample=n())
big=states[states$sample>50,]
county.clean4$sppState=as.character(paste(county.clean4$stateProvince,
                                          county.clean4$specificEpithet))
keep.list=as.character(paste(big$stateProvince,
                                          big$specificEpithet))

county.clean4$county=county.clean4$county.cleaned2
data3=county.clean4[which(county.clean4$sppState %in% keep.list),1:257]
data3$county=county.clean4$county.cleaned2
column.keep=c(1,27,37,40,43,47,48,58:65,68:78,103:111,125:131,
              138:140,148:151,175:178,189,197:210,
              217:221,226:210,240,249:254)
data4=data3[,column.keep]
write.csv(data4,"tutorial_data.csv")
