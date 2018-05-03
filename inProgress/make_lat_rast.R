library(raster)

test = raster::raster("/Users/mikejohnson/Downloads/wc2/wc2.0_30s_tmin_01.tif")

lat <- lon <- test
coords = coordinates(test$wc2.0_30s_tmin_01)
lat[] <- coords[, 2]

plot(lat)

writeRaster(lat, "/Users/mikejohnson/Desktop/latitudes.tif", options=c("TFW=YES"))


hope = raster::raster("/Users/mikejohnson/Desktop/latitudes.tif")

plot(hope)

lats = unique(coords[, 2])

write.csv(lats, "/Users/mikejohnson/Desktop/latitudes_unique.csv")
