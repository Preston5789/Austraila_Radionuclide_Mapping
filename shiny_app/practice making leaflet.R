setwd("/Users/Chloe/Desktop/Rprog/FinalProject_Rclass/shiny_app")
load("geo_aussie_data.Rdata")
load("river_map.Rdata")
load("river_mouthmap.Rdata")
library(dplyr)
geo_aussie_shiny <- geo_aussie_data %>% 
  mutate(sample_year = year(collection_date)) %>%
  select(sample_type, sample_year, Longitude, Latitude, Cu, As, 
         Hg, Pb, radionuclides)
points <- geo_aussie_shiny[geo_aussie_shiny$sample_type == "Terrestrial Animals" &
                             geo_aussie_shiny$sample_year == 2014, ]
popup_info <- points %>% paste0("<b>Copper:</b>  ", 
         points$Cu, "<br/>",
         "<b>Arsenic:</b>  ",
         points$As, "<br/>",
         "<b>Mercury:</b>  ",
         points$Hg, "<br/>",
         "<b>Lead:</b>  ",
         points$Pb, "<br/>",
         "<b>Radionuclides:</b>  ", 
         points$radionuclides)


leaflet()%>%
    addProviderTiles("Stamen.Watercolor")%>%
    addPolylines(data=river_map)%>%
    addPolylines(data=river_mouthmap, fillColor = "#0000FF")%>%
    addMarkers(data=points,popup=popup_info)


# everything from rachel's practice script on 12/1
setwd("/Users/Chloe/Desktop/Rprog/FinalProject_Rclass/shiny_app")
load("geo_aussie_data.Rdata")
load("river_map.Rdata")
load("river_mouthmap.Rdata")
library(dplyr)
geo_aussie_shiny <- geo_aussie_data %>% 
  mutate(sample_year = year(collection_date)) %>%
  select(sample_type, sample_year, Longitude, Latitude, Cu, As, 
         Hg, Pb, radionuclides) %>% 
  group_by(Longitude, Latitude, sample_type, sample_year) %>%
  summarize(Cu = max(Cu, na.rm = TRUE), 
            As = max(As, na.rm = TRUE),
            Hg = max(Hg, na.rm = TRUE), 
            Pb = max(Pb, na.rm = TRUE), 
            radionuclides = max(radionuclides, na.rm = TRUE)) %>%
  ungroup(Longitude, Latitude, sample_type, sample_year)

points <- geo_aussie_shiny[geo_aussie_shiny$sample_type == "Terrestrial Animals" &
                             geo_aussie_shiny$sample_year == 2014, ]

popup_info <- paste0("<b>Copper:</b>  ", 
                     points$Cu, "<br/>",
                     "<b>Arsenic:</b>  ",
                     points$As, "<br/>",
                     "<b>Mercury:</b>  ",
                     points$Hg, "<br/>",
                     "<b>Lead:</b>  ",
                     points$Pb, "<br/>",
                     "<b>Radionuclides:</b>  ", 
                     points$radionuclides)


leaflet()%>%
  addProviderTiles("Stamen.Watercolor")%>%
  addPolylines(data=river_map)%>%
  addPolylines(data=river_mouthmap, fillColor = "#0000FF")%>%
  addMarkers(data=points, ~Longitude, ~Latitude, popup=popup_info)
