library(shiny)
library(leaflet)
library(tidyverse)
library(lubridate)

load("geo_aussie_data.Rdata")
load("river_map.Rdata")
load("river_mouthmap.Rdata")

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

shinyServer(function(input, output, session) {
  
  filteredData <- reactive({
    geo_aussie_shiny %>% filter(sample_type == input$Substrate &
                                  sample_year >= input$slider1)
  })
  
  
  popups <- reactive({
    paste0("<b>Copper:</b>  ", 
                         filteredData()$Cu, "<br/>",
                         "<b>Arsenic:</b>  ",
                         filteredData()$As, "<br/>",
                         "<b>Mercury:</b>  ",
                         filteredData()$Hg, "<br/>",
                         "<b>Lead:</b>  ",
                         filteredData()$Pb, "<br/>",
                         "<b>Radionuclides:</b>  ", 
                         filteredData()$radionuclides)
  })
  
  output$RiverMap <- renderLeaflet({
    leaflet(geo_aussie_shiny) %>%
      addProviderTiles("Stamen.Watercolor")%>%
      setView(132.9107, -12.6848, zoom = 7) %>% 
      addPolylines(data=river_map)%>%
      addPolylines(data=river_mouthmap) 
  })

  observeEvent({
    input$Substrate
    input$slider1
    }, {
    leafletProxy("RiverMap", data = filteredData()) %>%
      clearMarkers() %>%
      addMarkers(data = filteredData(), lat = ~ Latitude, lng = ~ Longitude, 
                 popup = popups())
  })
  
})








# source("shiny mapping experiments.R")
# rivershape<-readShapeLines("CopyOfRiver Data/AUS_water_lines_dcw", 
                           # proj4string=CRS("+proj=longlat"))
# rivermouthshape<-readShapeLines("CopyOfRiver Data/AUS_water_areas_dcw.shp", 
                               # proj4string=CRS("+proj=longlat"))
# from another script file can execute the shiny app by using the runApp 
# command on the directory name : runApp("shiny_app")


# need to run the clean up script to generate clean_aussie_data
# need to run the river mapping emailed script to generate river and rivermouth data frames
#load("geo_aussie_data.Rdata")
#load("river_map.Rdata")
#load("river_mouthmap.Rdata")
#geo_aussie_shiny <- geo_aussie_data %>% 
 # mutate(sample_year = year(collection_date)) %>%
  #select(sample_type, sample_year, Longitude, Latitude, Cu, As, 
   #   Hg, Pb, radionuclides)

#shinyServer(function(input, output, session) {
 # filteredData <- reactive({
  #  geo_aussie_shiny[geo_aussie_shiny$sample_type == input$Substrate &
   #                   geo_aussie_shiny$sample_year >= input$slider1, ]
  #})
# points <- filteredData 
# popup_info <- eventReactive({
                     # paste0("<b>Copper:</b>  ", 
                      # points$Cu, "<br/>",
                      #"<b>Arsenic:</b>  ",
                      #points$As, "<br/>",
                       #"<b>Mercury:</b>  ",
                       #points$Hg, "<br/>",
                       #"<b>Lead:</b>  ",
                       #points$Pb, "<br/>",
                       #"<b>Radionuclides:</b>  ", 
                       #points$radionuclides)
#})

#output$RiverMap <- renderLeaflet({
 #   leaflet(geo_aussie_shiny) %>% setView(132.9107, -12.6848, zoom = 7)
#})

#observe({
 # leafletProxy("RiverMap", data = filteredData()) %>%
 #clearShapes() %>%
  #  addProviderTiles("Stamen.Watercolor")%>%
   # addPolylines(data=river_map)%>%
    #addPolylines(data=river_mouthmap) %>%
    #addCircleMarkers(data=filteredData())
#})

#})
   

