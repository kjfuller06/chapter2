library(rGEDI)
library(tidyverse)
library(raster)
library(sf)
library(sp)
library(leaflet)
library(leafsync)

# Study area boundary box coordinates
xmax = 150.8
ymax = -33.575
xmin = 150.7
ymin = -33.625

# Specifying the date range
daterange=c("2019-01-01","2021-01-01")

# Get path to GEDI data
gLevel1B<-gedifinder(product="GEDI01_B", xmax, ymax, xmin, ymin, version="001",daterange=daterange)
gLevel2A<-gedifinder(product="GEDI02_A", xmax, ymax, xmin, ymin, version="001",daterange=daterange)
gLevel2B<-gedifinder(product="GEDI02_B", xmax, ymax, xmin, ymin, version="001",daterange=daterange)

# Set output dir for downloading the files
outdir="data/gedi/richmond"

# Downloading GEDI data
gediDownload(filepath=gLevel1B,outdir=outdir) # geolocated waveforms
# gediDownload(filepath=gLevel2A,outdir=outdir) # elevation and height metrics
# gediDownload(filepath=gLevel2B,outdir=outdir) # canopy cover and vertical profile metrics

# Reading GEDI data
files <- list.files(outdir, full.names = TRUE)
gedilevel1b<-readLevel1B(paste0(files[1]))

# get GEDI puls geolocation
level1bGeo<-getLevel1BGeo(level1b=gedilevel1b,select=c("elevation_bin0"))
head(level1bGeo)

# Converting shot_number as "integer64" to "character"
level1bGeo$shot_number<-paste0(level1bGeo$shot_number)

# Converting level1bGeo as data.table to SpatialPointsDataFrame
level1bGeo_spdf<-SpatialPointsDataFrame(cbind(level1bGeo$longitude_bin0, level1bGeo$latitude_bin0), data=level1bGeo)

# Exporting level1bGeo as ESRI Shapefile
raster::shapefile(level1bGeo_spdf, substr(files[1], 1, nchar(files[1])-3))
level1bGeo_spdf = st_read(paste0(substr(files[1], 1, nchar(files[1])-3), ".shp"))

# mapping gedi data
# leaflet() %>%
#   addCircleMarkers(level1bGeo$longitude_bin0,
#                    level1bGeo$latitude_bin0,
#                    radius = 1,
#                    opacity = 1,
#                    color = "red")  %>%
#   addScaleBar(options = list(imperial = FALSE)) %>%
#   addProviderTiles(providers$Esri.WorldImagery) %>%
#   addLegend(colors = "red", labels= "Samples",title ="GEDI Level1B")

# Extracting GEDI full-waveform for a giving shotnumber
wf <- getLevel1BWF(gedilevel1b, shot_number="42170024000000001")

par(mfrow = c(2,1), mar=c(4,4,1,1), cex.axis = 1.5)

plot(wf, relative=FALSE, polygon=TRUE, type="l", lwd=2, col="forestgreen",
     xlab="Waveform Amplitude", ylab="Elevation (m)")
grid()
plot(wf, relative=TRUE, polygon=FALSE, type="l", lwd=2, col="forestgreen",
     xlab="Waveform Amplitude (%)", ylab="Elevation (m)")
grid()
