library(tidyverse)
library("rgdal")
library("maptools")
library("ggplot2")
library("plyr")
library(broom)
library(foreign)
library("maptools")
library(leaflet)
library(geosphere)

# Preston's distance script sent on 11/30/16 via email
Distance <- vector(,nrow(geo_aussie_data))
for(i in 1:nrow(geo_aussie_data)){
  Distance[i]=distm(c(geo_aussie_data$Longitude[i], geo_aussie_data$Latitude[i]), 
                    c( 132.9107,-12.6848), 
                    fun = distHaversine)
}
geo_aussie_data<-mutate(geo_aussie_data,
                        Distance = Distance)

##Water Radiation Concentration as a function of distance (7,000m)
Water_Rad_vs_Dis <- arrange(geo_aussie_data, Distance)
Water_Rad_vs_Dis<- filter(geo_aussie_data, Distance < 10000)
Water_Rad_vs_Dis <- filter(Water_Rad_vs_Dis, sample_type == "Water")
Rad_Close <- ggplot(data= Water_Rad_vs_Dis, aes(x=(Distance/1000), y=radionuclides))+ geom_point( color="blue", alpha=.8)+
  xlab("Distance (kilometers)")+ylab("Radionuclide Concentration (Bq/l)")+xlim(0,7)+
  ggtitle("Radionuclide Concentration \n in Water vs. Distance")+theme_bw()
ggsave("./Figures/Rad_Close.png", plot = Rad_Close, width = 5, height = 5)

##Water Radiation Concentration as a function of distance (250,0000m)
Water_Rad_vs_Dis_Long <- arrange(geo_aussie_data, Distance)
Water_Rad_vs_Dis_Long <- filter(Water_Rad_vs_Dis_Long, sample_type == "Water")
Rad_Far<-ggplot(data= Water_Rad_vs_Dis_Long, aes(x=Distance/1000, y=radionuclides))+ geom_point( color="blue", alpha=.8)+
  xlab("Distance (kilometers)")+ylab("Radionuclide Concentration (Bq/l)")+
  ggtitle("Radionuclide Concentration \n in Water vs. Distance")+theme_bw()
ggsave("./Figures/Rad_Far.png", plot = Rad_Far, width = 5, height = 5)

###Sediment Heavy Metal Concentration
Sed_Met_vs_Dis <- arrange(geo_aussie_data, Distance)
Sed_Met_vs_Dis <-filter(Sed_Met_vs_Dis, sample_type == "Freshwater Sediment")
Sed_Met_vs_Dis<-filter(geo_aussie_data, Distance < 10000)
Heavy_Metal<-ggplot(data= Sed_Met_vs_Dis)+ 
  geom_point(aes(x = Distance/1000, y = Pb, color="Pb"))+
  geom_point(aes(x = Distance/1000, y = Cu, color="Cu"))+
  geom_point(aes(x = Distance/1000, y = As, color ="As"))+
  geom_point(aes(x = Distance/1000, y = Hg, color ="Hg"))+
  xlab("Distance (kilometers)")+ylab("Heavy Metal Concentration (mg/l)")+
  ggtitle("Metal Concentration \n in Sediment vs. Distance")+
      scale_colour_manual(name = 'Heavy Metal', 
        values = c('Pb'='blue','Cu'='red','As'='black','Hg'='green'), labels=c('Pb','Cu','Hg','As'))+theme_bw()
ggsave("./Figures/Heavy_Metal.png", plot = Heavy_Metal, width = 5, height = 5)

###Plottig Mercury
Merc<-ggplot(data= Sed_Met_vs_Dis)+ 
  geom_point(aes(x = Distance/1000, y = Hg), color="blue")+
  xlab("Distance (kilometers)")+ylab("Mercury Concentration (mg/l)")+
  ggtitle("Mercury Concentration \n in Water vs. Distance")+theme_bw()
ggsave("./Figures/Merc.png", plot = Merc, width = 5, height = 5)

###Molusc Concentration of 1976 vs 1982
Mollusc_Rad_vs_Time <-filter(geo_aussie_data, sample_type == "Mollusc")
Mollusc_Rad_vs_Time <-mutate(Mollusc_Rad_vs_Time, sample_year = year(collection_date))
Mollusc_Rad_vs_Time <-arrange(Mollusc_Rad_vs_Time, sample_year)
Mollusc<-ggplot(data= Mollusc_Rad_vs_Time)+ 
  geom_point(aes(x = sample_year, y = radionuclides, color=Distance), alpha=.8)+
  scale_fill_brewer(name="Distance (km)")+ xlab("Sample Year")+ylab("Radionuclide Concentration (Bq/kg)")+
  ggtitle("Radionuclide Concentration \n in Molluscs vs. Time")+theme_bw()
ggsave("./Figures/Mollusc.png", plot = Mollusc, width = 5, height = 5)

