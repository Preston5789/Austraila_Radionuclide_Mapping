library(tidyverse)
library(lubridate)
library(stringr)
library(rgdal)
library(sp)
library(maptools)
library(ggmap)
library(sp)


# Script for Map Generation
# This script generates and saves two maps, map_large.png and map_small.png


northern_terr <- get_map("Jabiru", zoom = 7,
                     source = "google", maptype = "hybrid")
ranger_location <- tibble(long = 132.9107, lat = -12.6848)
temp_data <- filter(geo_aussie_data, !(sample_type=="NA"))
map_large <- ggmap(northern_terr, extent = "device") +
    geom_point(data = temp_data, aes(x = Longitude, y = Latitude), 
             size = .5, color = "red")+
    geom_point(data = ranger_location, aes(x = long, y = lat), 
               size = 1.5, color = "green") +
    geom_text(data = ranger_location, aes(x = long, y = lat,label = "Ranger Mine"),
          colour = "white", size = 4, hjust = 1, vjust = 1) +
    ggtitle("Sample Points in the Vicinity of the Ranger Mine")

northern_terr_zoomed <- get_map("Jabiru", zoom = 9,
                         source = "google", maptype = "hybrid")
ranger_location <- tibble(long = 132.9107, lat = -12.6848)
temp_data <- filter(geo_aussie_data, !(sample_type=="NA"))
map_small <- ggmap(northern_terr_zoomed, extent = "device") +
  geom_point(data = temp_data, aes(x = Longitude, y = Latitude, color = sample_type), 
             size = .5, position = "jitter")+
  geom_point(data = ranger_location, aes(x = long, y = lat), 
             size = 1.5, color = "green") +
  geom_text(data = ranger_location, aes(x = long, y = lat,label = "Ranger Mine"),
            colour = "white", size = 4, hjust = 1, vjust = 1) +
  scale_color_brewer(palette = "Set1", name = "Sample Substrate") +
  ggtitle("Sample Points by Substrate in the Vicinity of the Ranger Mine")

ggsave("./Figures/map_large.png", plot = map_large, width = 7, height = 5)
ggsave("./Figures/map_small.png", plot = map_small, width = 7, height = 5)