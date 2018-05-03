ws = rgdal::readOGR("/Users/mikejohnson/Desktop/gagesII_9322_point_shapefile/gagesII_9322_sept30_2011.shp",
                    stringsAsFactors = FALSE)



ws = data.frame(ID = as.numeric(ws$STAID), LAT = ws$LAT_GAGE, LONG =ws$LNG_GAGE)

save(ws, file ="/Users/mikejohnson/Desktop/wateshed.rda")
ws@proj4string
