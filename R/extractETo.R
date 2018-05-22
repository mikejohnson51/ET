extractET = function (stations = NULL, ET = NULL){
  
  data = NULL
  
  for (j in seq_along(stations)){
    
    new <- vector(mode = "numeric")
    ET = ET %>% projectRaster(crs = stations@proj4string)
    
    for (i in 1:dim(ET)[3]) {
      new <- append(new, raster::extract(ET[[i]], cbind(stat[j,]$longitude, stat[j,]$latitude)))
    }
    data = cbind(data, new)
  }
  data = as.data.frame(cbind(names(ET), data))
  
  names(data) = c("Index", stat$siteid)
  return(data)
}
