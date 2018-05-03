# Data Inputs -------------------------------------------------------------

  lat.data = data.table::fread("/Users/mikejohnson/Desktop/latitudes_unique.csv")
  
  dl_rast = raster::raster("/Users/mikejohnson/Desktop/latitudes.tif")
  
  months.doy = list(jan = 1:31,    feb = 32:59, 
                    mar = 60:90,   apr = 91:120,       
                    may = 121:151, jun = 152:181,     
                    jul = 182:212, aug = 213:243,
                    sep = 244:273, oct = 274:304,
                    nov = 305:334, dec =335:365
                    )

# Execute -----------------------------------------------------------------

  average_daylengths(months.doy)

# Scripts -----------------------------------------------------------------

  average_daylengths = function(periods, statistic = "average"){
  
  for(i in seq_along(periods)){
    
    file = paste0("/Users/mikejohnson/Desktop/day_length_rasters/", 
                  toupper(names(months.doy)[i]), 
                  "_", statistic, "_daylength.tif")
    
    if(!file.exists(file)){
      
      data = daylight(lat = lat.data$x , DOY = periods[[i]], timestep = "sec", statistic = statistic)
      message("Data generated")
      
      mat = matrix(data$DL_sec , length(data$DL_sec) , 43200 )
      message("Matrix generated")
      
      r = raster(mat)
      message("Raster generated")
      
      extent(r) <- extent(dl_rast)
      res(r) <- res(dl_rast)
      crs(r) <- crs(dl_rast)
      message("Raster modified")
      
      writeRaster(r, file, options=c("TFW=YES"))
      
      message("Finished (", i, "/", length(months.doy),")")
    } else {
      message("Raster ", i, " already exists. Moving on to the next ...")
    }
    
  }
  
}

  daylight = function(lat, DOY, timestep = 'hr', statistic ="average"){
  
  if(timestep == "hr" ) { ts  = 1 }
  if(timestep == "min") { ts = 60 }
  if(timestep == "sec") { ts = 60 * 60 } 
  
  dl = NULL
  
  for(j in seq_along(lat)){
    
    tmp = NULL
    
    for(i in seq_along(DOY)){
      
      P = asin(.39795 * cos(.2163108 + 2 * atan(.9671396 * tan(.0086 * (DOY[i] -186)))))
      
      a <- (sin(0.8333 * pi/180) + sin(lat[j] * pi/180) * sin(P))/(cos(lat[j] *  pi/180) * cos(P))
      
      a <- pmin(pmax(a, -1), 1)
      
      DL <- 24 - (24/pi) * acos(a)
      
      tmp = append(tmp, DL * ts)
    }
    
    if(statistic == 'average') { dl = rbind(dl, mean(tmp))}
    if(statistic == 'sum')     { dl = rbind(dl, sum(tmp)) }
    
  }
  
  fin = as.data.frame(cbind(lat = lat, DL = dl))
  colnames(fin) <- c("lat", paste0("DL_", timestep))
  
  return(fin)
  
}

