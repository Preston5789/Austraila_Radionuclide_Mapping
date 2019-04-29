library(tidyverse)
library(lubridate)
library(stringr)
library(rgdal)
library(sp)
library(maptools)
library(ggmap)
library(sp)

# guess_max set because of parsing errors
aussie_data <- read_csv("data_raw/mmc1.csv", guess_max = 5000)

# initial bits of cleanup
# dropping some non-useful columns - leaves 5060 obs. of 53 variables
clean_aussie_data <- dplyr::select(aussie_data, -`Database ID`, `Composite count`,
                            -`Family code`, -Datum, -Notes, -Reference, -Geocoding, 
                            -(contains("err")), -`Mussel age (y)`)

# renaming some columns to simplify R codes
# deliberately left bare element names capitalized, but shifted isotope names
clean_aussie_data <- clean_aussie_data %>%
  dplyr::rename(sample_id = `Sample ID`, ecosystem = Ecosystem, sample_type = `Sample type`,
         common_name = `Common name`, sci_name = `Scientific name`, bush_group = `Bush food group`,
         wildlife_group = `Wildlife group`, compartment = Compartment, 
         composite_count = `Composite count`, sex = Sex, soil_depth = `Soil depth (cm)`,
         collection_date = `Collection date (day/month/year)`, location = Location,
         status = Status, easting = Easting, northing = Northing, zone = Zone,
         u238 = `U-238`, u234 = `U-234`, th230 = `Th-230`, ra226 = `Ra-226`, 
         pb210 = `Pb-210`, po210 = `Po-210`, th232 = `Th-232`, ra228 = `Ra-228`, 
         th228 = `Th-228`, ac227 = `Ac-227`, k40 = `K-40`, 
         dry_mass_fraction = `Dry mass fraction`)
# original dataset uses wildlife_group only for a fine-grained division of 
# plant and animal samples.  Here I use ecosystem and sample_type to create 
# entries in wildlife_group for soil and sediment samples, as well as for fruits
# that were not counted in other types. Set the wildlife_group to a factor.
# 5060 entries, 53 variables
clean_aussie_data <- clean_aussie_data %>%
  mutate(wildlife_group = ifelse(is.na(wildlife_group), 
                                 paste0(ecosystem,"-",sample_type), wildlife_group ))
#
# set several values to factors: ecosystem, sample_type, wildlife_group
# convert collection_date to a date
clean_aussie_data$wildlife_group <- as.factor(clean_aussie_data$wildlife_group)
clean_aussie_data$ecosystem <- as.factor(clean_aussie_data$ecosystem)
clean_aussie_data$sample_type <- as.factor(clean_aussie_data$sample_type)
clean_aussie_data$collection_date <- dmy(clean_aussie_data$collection_date)
#
# entries in sample_id are not unique, so create an entry number for later use
clean_aussie_data$entry_num <- 1:nrow(clean_aussie_data)
#
# A number of sample results were reported as below detection limits, in the form
# of "<value", where value is the detection limit.  Highly conservative to
# use the LOD as the value but what we elected to do
clean_aussie_data <- clean_aussie_data %>%
  mutate(u234 = as.numeric(str_replace(u234, "<", "")),
         th230 = as.numeric(str_replace(th230, "<", "")),
         ra226 = as.numeric(str_replace(ra226, "<", "")),
         pb210 = as.numeric(str_replace(pb210, "<", "")),
         th232 = as.numeric(str_replace(th232, "<", "")),
         po210 = as.numeric(str_replace(po210, "<", "")),
         k40 = as.numeric(str_replace(k40, "<", "")),
         u238 = as.numeric(str_replace(u238, "<", "")),
         ra228 = as.numeric(str_replace(ra228, "<", "")),
         th228 = as.numeric(str_replace(th228, "<", "")),
         Al = as.numeric(str_replace(Al, "<", "")),
         As = as.numeric(str_replace(As, "<", "")),
         Ba = as.numeric(str_replace(Ba, "<", "")),
         Ca = as.numeric(str_replace(Ca, "<", "")),
         Cd = as.numeric(str_replace(Cd, "<", "")),
         Co = as.numeric(str_replace(Co, "<", "")),
         Cr = as.numeric(str_replace(Cr, "<", "")),
         Cu = as.numeric(str_replace(Cu, "<", "")),
         Fe = as.numeric(str_replace(Fe, "<", "")),
         Hg = as.numeric(str_replace(Hg, "<", "")),
         K = as.numeric(str_replace(K, "<", "")),
         Mg = as.numeric(str_replace(Mg, "<", "")),
         Mn = as.numeric(str_replace(Mn, "<", "")),
         Na = as.numeric(str_replace(Na, "<", "")),
         Ni = as.numeric(str_replace(Ni, "<", "")),
         P = as.numeric(str_replace(P, "<", "")),
         Pb = as.numeric(str_replace(Pb, "<", "")),
         Rb = as.numeric(str_replace(Rb, "<", "")),
         S = as.numeric(str_replace(S, "<", "")),
         Sb = as.numeric(str_replace(Sb, "<", "")),
         Se = as.numeric(str_replace(Se, "<", "")),
         Th = as.numeric(str_replace(Th, "<", "")),
         U = as.numeric(str_replace(U, "<", "")),
         V = as.numeric(str_replace(V, "<", "")),
         Zn = as.numeric(str_replace(Zn, "<", ""))
         )
emitters <- c("u238", "u234", "th230", "ra226", "pb210", "po210", "th232",
                    "ra228", "th228", "ac227", "k40")
clean_aussie_data$radionuclides <- rowSums(clean_aussie_data[, emitters], na.rm = TRUE)
#
# consolidate the wildlife_group factors into sample_type
clean_aussie_data <- clean_aussie_data%>% 
  mutate(sample_type = case_when(
    wildlife_group == "Terrestrial-Bird" ~ "Terrestrial Animals",
    wildlife_group == "Terrestrial-Reptile" ~ "Terrestrial Animals",
    wildlife_group == "Terrestrial-Mammal" ~ "Terrestrial Animals",
    wildlife_group == "Terrestrial-Grasses and Herbs" ~ "Terrestrial Plants",
    wildlife_group == "Terrestrial-Plant" ~ "Terrestrial Plants",
    wildlife_group == "Terrestrial-Soil" ~ "Terrestrial Soil",
    wildlife_group == "Freshwater-Bird" ~ "Freshwater Animals",
    wildlife_group == "Freshwater-Reptile" ~ "Freshwater Animals",
    wildlife_group == "Freshwater-Fish" ~ "Fish",
    wildlife_group == "Freshwater-Mollusc" ~ "Mollusc",
    wildlife_group == "Freshwater-Sediment" ~ "Freshwater Sediment",
    wildlife_group == "Freshwater-Vascular Plant" ~ "Freshwater Plant",
    wildlife_group == "Freshwater-Water" ~ "Water",
    TRUE ~ "NA"))
# 
# peeling out the geospatial information for plotting
#geo_data <- select(clean_aussie_data, sample_id, easting, northing, zone)
# filter out a few NAs
geo_data <- subset(clean_aussie_data, easting != "" | northing != "")
#
# the geo_data is in UTM coordinates, need to convert to lat-long
# the lat-long conversion requires that the data be split between the UTM
# zones.  In this case, 52S and 53S.  From here on everything is split.
geo_data_52 <- subset(geo_data, zone == "52S")
geo_data_53 <- subset(geo_data, zone == "53S")
coords_52 <- cbind(Easting = as.numeric(as.character(geo_data_52$easting)),
                   Northing = as.numeric(as.character(geo_data_52$northing)))
coords_53 <- cbind(Easting = as.numeric(as.character(geo_data_53$easting)),
                   Northing = as.numeric(as.character(geo_data_53$northing)))
#
# Create the SpatialPointsDataFrame
spatial_52 <- SpatialPointsDataFrame(coords_52, data = 
                                       data.frame(geo_data_52$entry_num), 
                                     proj4string = CRS("+init=epsg:32752"))
spatial_53 <- SpatialPointsDataFrame(coords_53, data = 
                                       data.frame(geo_data_53$entry_num), 
                                     proj4string = CRS("+init=epsg:32753"))
#
# Convert to Lat Long
# Convert from Eastings and Northings to Latitude and Longitude
spatial_52_ll <- spTransform(spatial_52, CRS("+init=epsg:4326"))
spatial_53_ll <- spTransform(spatial_53, CRS("+init=epsg:4326"))
#
# we also need to rename the columns 
colnames(spatial_52_ll@coords)[colnames(spatial_52_ll@coords) == "Easting"]<- "Longitude" 
colnames(spatial_52_ll@coords)[colnames(spatial_52_ll@coords) == "Northing"]<- "Latitude"
colnames(spatial_53_ll@coords)[colnames(spatial_53_ll@coords) == "Easting"]<- "Longitude" 
colnames(spatial_53_ll@coords)[colnames(spatial_53_ll@coords) == "Northing"]<- "Latitude"
#
# convert back to data frames
geo_data_52_ll <- as.data.frame(spatial_52_ll)
geo_data_52_ll <- dplyr::rename(geo_data_52_ll, entry_num = geo_data_52.entry_num)
geo_data_53_ll <- as.data.frame(spatial_53_ll)
geo_data_53_ll <- dplyr::rename(geo_data_53_ll, entry_num = geo_data_53.entry_num)
#
# merge the two lat-long data sets into one, then join back into original
# cleaned data set, producing a new data frame
geo_data_ll <- rbind(geo_data_52_ll, geo_data_53_ll)
geo_aussie_data <- left_join(geo_data_ll, clean_aussie_data, by = "entry_num")
#
# save geo_aussie_data for use elsewhere
save(geo_aussie_data, file = "./shiny_app/geo_aussie_data.Rdata")
