library(tidyverse)
library("rgdal")
library("maptools")
library("ggplot2")
library("plyr")
library(broom)
library(foreign)
library("maptools")
library(leaflet)

###For the river lines
rivershape<-readShapeLines("River Data/AUS_water_lines_dcw", proj4string=CRS("+proj=longlat"))
river_map<-rivershape[str_detect(rivershape@data$NAM, "ALLIGATOR"), ]

 #For the River mouth
rivermouthshape<-readShapePoly("River Data/AUS_water_areas_dcw.shp", proj4string=CRS("+proj=longlat"))
river_mouthmap<-rivermouthshape[str_detect(rivermouthshape@data$NAM, "ALLIGATOR"), ]

#library(leaflet)
 # leaflet()%>%
   # addProviderTiles("Stamen.Watercolor")%>%
  #addPolylines(data=river_map)%>%
# addPolylines(data=river_mouthmap, fillColor = "#0000FF")%>%
    # addCircleMarkers(data=geo_data_ll, radius=.1)
  
###Convert to Data Frame (Takes a very long time)
river<-tidy(rivershape)
river<-filter(river,river$lat < -12 & river$lat > -13.7)
river<-filter(river,river$long < 133.5 & river$long > 132.2)

  
rivermouth<-tidy(rivermouthshape)
rivermouth<-filter(rivermouth, rivermouth$lat < -12 & rivermouth$lat > -12.75)
rivermouth<-filter(rivermouth, rivermouth$long < 133 & rivermouth$long > 132.4)

save(rivermouth, file = "./shiny_app/rivermouth.Rdata")
save(river, file = "./shiny_app/river.Rdata")

# save the other non data frame files to shiny app page
save(river_map, file = "./shiny_app/river_map.Rdata")
save(river_mouthmap, file = "./shiny_app/river_mouthmap.Rdata")

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
  