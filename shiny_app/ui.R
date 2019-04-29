library(leaflet)

shinyUI(fluidPage(
  titlePanel("Australia's Ranger Uranium Mine: Measuring Heavy Metals and Radionuclide 
             Presence in the Alligator Rivers Region"),
           fluidRow(
             column(6,
                  img(src = "Ranger2005.jpg", height = 100, width = 375),
                  h6("Image of Ranger Treatment plant, with mine
                       pit (source www.world-nuclear.org)"),
                    fluidRow(
                      column(12, h4(em("Where and when do we see metals and radionuclides?"))),
                      column(6, selectInput("Substrate",
                             label = h5("Sample Type:"),
                            choices = list("Terrestrial Animals" = "Terrestrial Animals", 
                            "Terrestrial Plants" = "Terrestrial Plants",
                            "Terrestrial Soil" = "Terrestrial Soil",
                           "Freshwater Animals" = "Freshwater Animals",
                             "Fish" = "Fish",
                              "Mollusc" = "Mollusc",
                        "Freshwater Sediment" = "Freshwater Sediment",
                            "Freshwater Plant" = "Freshwater Plant",
                             "Water" = "Water"))),
                      column(6, sliderInput("slider1",
                                            label = h5("Year of Sampling:"),
                            min = 1976, max = 2015, value = 1, sep = ""))
                            )),
               column(6, position = "right", 
                      tableOutput("check"),
                   h4("Map of Alligator Rivers Sample Sites"),
                  
                    leafletOutput("RiverMap")
                   ))
                    
           ))
    


  #sidebarLayout(
   # sidebarPanel(width = 5,
    #            h4("Where do we see metals and radionuclides?"),
     #            img(src = "Ranger2005.jpg", height = 100, width = 250),
      #           h6("Image of the Ranger Treatment plant, with mine
       #            pit beyond (source www.world-nuclear.org)"),
        #        br(),
         #       checkboxGroupInput("Substrate",
          #                        label = h4("Substrate"),
           #     choices = list("Terrestrial Animals" = "Choice 1", 
            #                   "Terrestrial Plants" = "Choice 2",
             #                  "Terrestrial soil" = "Choice 3",
                 #              "Freshwater Animals" = "Choice 4",
                  #            "Fish" = "Choice 5",
                   #            "Mollusc" = "Choice 6",
                    #           "Freshwater Sediment" = "Choice 7",
                     #         "Freshwater Plant" = "Choice 8",
                      #         "Water" = "Choice 9"),
                #select = 1)),
      #column(4, checkboxGroupInput("Contaminant",
       #                      label = h5("Contaminant:"),
        #                     choices = list("Cu" = "Choice 1", 
         #                                   "As" = "Choice 2",
          #                                  "Hg" = "Choice 3",
           #                                 "Pb" = "Choice 4",
            #                                "Radionuclides" = "Choice 5"),
             #                select = 1)
   # mainPanel("Map of Alligator Rivers Area"
              #plotOutput())
#  ))
#))
