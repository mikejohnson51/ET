getETo = function (tile = NULL, year = NULL, timeCollapse = NULL){
  
  wu = NULL
  
  for( i in seq_along(year)){
    #ap = find_closest_airport(location = c(stat[1,]@bbox[1,1], stat[1,]@bbox[2,1] ))
    ap = find_closest_airport(location = c(mean(tile@bbox[1,]), mean(tile@bbox[2,]) ))
    
    wu.km    = getWU(year = year[i], month = 1:12, airport_code = ap[1]$Digit4, type = 'monthly')
    wu1 = wu.km$Wind_avg[1:365] * .277778
    wu = append(wu, wu1)
  }
  
  if(!is.null(timeCollapse)){
    wu = suppressWarnings(  colMeans(matrix(wu, timeCollapse))  )
  }
  
  for( i in seq_along(wu)){
    if(is.na(wu[i])){wu[i] = mean(wu, na.rm = T)}
  }
  
  if(is.na(wu[1])){stop("WIND DATA NOT FOUND FOR THIS YEAR")}
  
  param.list = c("Tmax", "Tmin", "vp", "srad", "dayl")
  
  daymet = suppressWarnings(  getDaymet(tile.ids = tile, parameters = param.list, year = year, crop = FALSE, aggregate = timeCollapse) )
  tair = (daymet$tmax + daymet$tmin) / 2
  vp   = daymet$vp * .001
  rad  = ((daymet$srad * daymet$dayl) / 1000000) * 277.78
  
  ET = pm.cimis(Tair = tair, vp = vp, Rnet = rad, wind = wu)
  
  return(ET)
}