find_closest_airport = function(location = NULL, number = 5){
  
  load("data/airports.rda")

  coords = cbind(ap$V8, ap$V7)
  air = SpatialPointsDataFrame(coords, ap)
  
  if(class(location) == 'numeric') { point = SpatialPoints(cbind(location[1], location[2]))
  } else { x = geocode(location)
  point = SpatialPoints(cbind(x$longitude, x$latitude))
  }
  
  air@proj4string = CRS("+init=epsg:4326")
  point@proj4string = CRS("+init=epsg:4326")
  
  dist = spDistsN1(air, point, longlat = T)
  
  ndx = cbind(ap[(order(dist)[1:number])],  dist[(order(dist)[1:number])])
  names(ndx) = c("ID","Name", "City", "Country", "Digit3", "Digit4", "Lat", "Long", "UK", "UK","UK", "UK", "UK","UK", "Distance_km")
  
  return(ndx)
}

