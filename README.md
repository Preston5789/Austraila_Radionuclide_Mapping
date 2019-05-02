# Mapping Radionuclide Contamination Down the Alligator River

## Background

<p align="center">
  <img src="https://github.com/Preston5789/Austraila_Radionuclide_Mapping/blob/master/Austrialia_Pics/MapofRangerMine.png" width="350" title="hover text">
</p>
The Alligator Rivers Region is a province in the wet-dry tropics of northeastern Australia. The land in this region is rich in uranium, and since 1980 has been home to a large mine: The Ranger Uranium mine. An Australian government entity called the Environmental Research Institute of the Supervising Scientist (ERISS) has been collecting animal and environmental samples from the land around the mine and the Alligator Rivers Watershed since mine activity began. The samples have been measured for many different mine contaminants including the heavy metals Cu, As, Pb, Hg, and the radionuclides U-234, U-238, Th-230, Th-232, Ra-226, Ra-228, Pb-210, Po-210, Th-228, Ac-227, and K-40. All of these metals and radionuclides are naturally occurring, but may have been released during mining and milling at the mine.

Samples from flora, fauna, and soil and water have been gathered by the ERISS. The specific sample types can be clustered based on their ecological niche and purpose in the watershed, to contain the following groups: water, fish, molluscs, freshwater animals, freshwater plants, freshwater sediment, terrestrial animals, terrestrial plants, and terrestrial soil.


### Research Question
Have mining and milling operations at the Ranger Mine contaminated the surrounding Alligators River Region with radionuclides and metals.

–	Where are the sample types of interest located in relation to the mine?

–	How do the concentrations of radionuclides and metals change with distance from the mine?

### Analysis
The initial dataset was made available as a .xlsx file. The only manual process was to load the file into Excel and save as a .csv file; all other data cleaning was performed using an R script. Most of the data cleanup consisted of cosmetic and convenience changes, renaming variables and setting data types. We created a variable called sample_type to group samples by substrate, such as Terrestrial Plants or Fish. This is important for both our analysis and for the Shiny app.
The dataset includes geospatial data using Easting and Northing in two different zones of a Mercator Projection. We used functions from the rgdal and sp packages to convert to lat-long coordinates, which we were then able to plot using ggplot2.
A number of sample results were reported as below detection limits, in the form of "<value", where value is the detection limit rather than an actual measured value. We discussed several possibilities for managing these results. We found references that directly used the LOD as a result (highly conservative), that used 0 as the result (effectively loses results), or divided the LOD by a factor (2 or √2) for use as a result (could be considered arbitary). We elected to go the highly conservative route and use the LOD as the value.

### Results
<p align="center">
  <img src="https://github.com/Preston5789/Austraila_Radionuclide_Mapping/blob/master/Austrialia_Pics/Graph1.png" width="350" title="hover text">
</p>
If the presence of the mine had a direct impact on the radionuclide concentrations in the environment, one would expect to see concentrations of radionuclides increase over time from the point before the mine was established to after. However, there is no apparent data to indicate an upward trend in radionuclide concentration over time, nor does the radionuclide concentration seem to depend on distance for a particular year.
The fluctuations in radionuclide content is most likely caused by naturally radionuclide concentrations in the local geology. There has been a presence of radionculides in the surrounding geology preceding any excavation from the mine.

## R Shiny


## Built With

* [Python-Binance](https://github.com/sammchardy/python-binance) - API for stock price websocket, buying, and selling
* [Numpy](https://www.numpy.org/) - scientific computing with Python
* [Scipy](https://www.scipy.org/) - used for linear regression calculations


## Authors

* **Preston Phillips** - [Preston5789](https://github.com/Preston5789)


