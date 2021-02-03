library(rGEDI)
library(tidyverse)
library(raster)
library(sf)

nsw = st_read("data/NSW_sans_islands.shp")
# Study area boundary box coordinates
cords = st_bbox(nsw)
bb = c(cords[3] + 0.1, 
       cords[4] + 0.1, 
       cords[1] - 0.1, 
       cords[2] - 0.1)

# Specifying the date range
daterange=c("2019-01-01","2021-01-01")

# Get path to GEDI data
gLevel1B<-gedifinder(product="GEDI01_B", bb[1], bb[2], bb[3], bb[4], version="001",daterange=daterange)
gLevel2A<-gedifinder(product="GEDI02_A", bb[1], bb[2], bb[3], bb[4], version="001",daterange=daterange)
gLevel2B<-gedifinder(product="GEDI02_B", bb[1], bb[2], bb[3], bb[4], version="001",daterange=daterange)
