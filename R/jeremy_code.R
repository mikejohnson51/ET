library(USAboundariesData)
library(USAboundaries)
library(sf)
library(sp)
library(RColorBrewer)


load("/Users/mikejohnson/Desktop/watersheds.rda")

data = as.data.frame(
  read.csv(
    "/Users/mikejohnson/Library/Mobile Documents/com~apple~CloudDocs/Full_Flow_3_slim.csv"
  )
)

numberOfDays <- function(date) {
  m <- format(date, format = "%m")

  while (format(date, format = "%m") == m) {
    date <- date + 1
  }

  return(as.integer(format(date - 1, format = "%d")))
}

getStationData = function( data = NULL, stationID = NULL, timestep = "monthly"){

  items = list()

  for(k in seq_along(stationID)){
    stat.data = data[data$GAGE_ID == stationID[k], ]

    info = stat.data[, 1:3]

    PPT  = stat.data[, grepl('PPT', colnames(stat.data))]
    Q    = stat.data[, grepl('Q', colnames(stat.data))]
    TMAX = stat.data[, grepl('TMAX', colnames(stat.data))]

    date.matrix = NULL

    for (i in 1:nrow(PPT)) {
      dates  = as.Date(paste(info$YEAR[i], sprintf("%02d", 1:12), "01", sep = "-"), "%Y-%m-%d")
      days = NULL

      for (j in seq_along(dates)) {
        days = append(days, numberOfDays(dates[j]))
      }

      date.matrix = rbind(date.matrix, days)

    }

    Q.m3   = Q  * .0283 * 86400 * date.matrix
    PPT.m3 = PPT  * 0.001 * info$AREA[1]
    ET     = PPT.m3 - Q.m3

    colnames(ET)   = paste0("ET_", sprintf("%02d", c(10:12, 1:9)))

    ET.P = ET / PPT.m3
    colnames(ET.P) = paste0("Ratio_", sprintf("%02d", c(10:12, 1:9)))

    fin = as.data.frame(cbind(info, Q.m3, PPT.m3, TMAX, ET, ET.P))


    if(timestep == 'annual'){
      fin = data.frame(
        info,
        Q = rowMeans(fin[, grepl('Q', colnames(fin))]),
        PPT = rowMeans(fin[, grepl('PPT', colnames(fin))]),
        TMAX = rowMeans(fin[, grepl('TMAX', colnames(fin))]),
        ET = rowMeans(fin[, grepl('ET', colnames(fin))]),
        ET.P = rowMeans(fin[, grepl('Ratio', colnames(fin))]),
        DECADE = substr(info$YEAR, 2, 3)
      )
    }


    if(length(stationID) > 1 ){
      items[[paste(stationID[k])]] = fin
    } else { items = fin}
  }


  return(items)

}

lmStats = function(stationData = NULL){

  stats = NULL

  for(i in 1:length(stationData) ){

    mod  = lm(ET ~ PPT, data = stationData[[i]])

    coef = mod$coefficients[2]
    r2 = summary(mod)$adj.r.squared
    f = summary(mod)$fstatistic
    p <- pf(f[1],f[2],f[3],lower.tail=F)

    # tmp = c(as.numeric(names(stationData)[i]), coef, r2, p)

    stats = rbind(stats, c(as.numeric(names(stationData)[i]), coef, r2, p))
  }

  colnames(stats) = c("ID", "coeff", "r2", "p")
  stats = as.data.frame(stats, stringsAsFactors = F, row.names = NULL)

  return(stats)
}

plotData = function(data = NULL, stats = NULL, save.path = NULL, clear.folder = TRUE){

  if(all(!is.null(save.path), isTRUE(clear.folder))){
    file.remove(list.files(save.path, full.names = T))
  }

  for(i in 1:length(data)){

    df = data[[i]]
    id = unique(df$GAGE_ID)

    if(!is.null(save.path)){

      png(paste0(save.path,"/img_", id, ".png"), width = 16, height = 8, units = 'in', res = 300)
    }

    par(mfrow = c(2,3), mar = c(3,3,3,3))

    plot(df$Q, pch = 16, cex = 1.5, main = "Discharge", col = "blue")
    plot(df$PPT, pch = 16, cex = 1.5, main = "PPT", col = "purple")
    plot(df$ET, pch = 16, cex = 1.5, main = "ET", col = "darkgreen")
    plot(df$TMAX, pch = 16, cex = 1.5, main = "Tmax", col = "red")
    plot(df$ET.P, pch = 16, cex = 1.5, main = "ET/P", col = "black")
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')

    if(!is.null(stats)){
      id = unique(df$GAGE_ID)
      text(x = 0.5, y = 0.5,
           paste("Station ID:", id, "\n\n",
                 "ET ~ PPT summary:\n\n",
                 "Slope Coefficent:", round(stats[stats$ID == id,]$coeff, 2) , "\n",
                 "R2:",    round(stats[stats$ID == id,]$r2, 2), "\n",
                 "P-value:",   round(stats[stats$ID == id,]$p , 8), "\n"
           ), cex = 1.6, col = "black")
    }
    if(!is.null(save.path)){
     dev.off()
    }
  }
}

data = data[, 1:51]


stations = unique(data$GAGE_ID)

# Starting Code -----------------------------------------------------------

test = getStationData(data = data, stationID = stations[1:200], timestep = "annual")

test.stats = lmStats(test)

#bad.stations = test[names(test) %in% test.stats[test.stats$r2 < 0, ]$ID]


#plotData(data = bad.stations[1], stats = test.stats, save.path = "/Users/Mike/Desktop/jeremy_images")



hmm = ws[ws$ID %in% names(test),]

total <- merge(test.stats,hmm, by="ID")

coords = cbind(total$LONG, total$LAT)

usa = as(us_states(map_date = NULL, resolution = 'low'), 'Spatial')

usa = usa[ !(usa$name %in% c("Alaska", "Hawaii", "Puerto Rico" )),]

sp = SpatialPointsDataFrame(coords, total, proj4string = usa@proj4string)
ColRamp <- designer.colors(n=100, col=brewer.pal(9, "YlOrRd"))

color <- cut(sp$r2, 
             breaks = quantile(sp$r2, 
             c(0, 0.25, 0.5, 0.75, 1)), 
             labels=sequential_hcl(4))


plot(usa)
plot(sp, add = T, col= 'black', bg=color, pch=21, cex = sp$r2 * 5)


usa$name



 PPT.10 = aggregate(x = annual.avg$PPT,
                   by = list(annual.avg$DECADE),
                   FUN = mean)[, 2]

ET.10 = aggregate(x = annual.avg$ET,
                  by = list(annual.avg$DECADE),
                  FUN = mean)[, 2]

TMAX.10 = aggregate(x = annual.avg$TMAX,
                    by = list(annual.avg$DECADE),
                    FUN = mean)[, 2]


wide.data = reshape(sub.data,
                    idvar = "GAGE_ID",
                    timevar = "YEAR",
                    direction = "wide")
head(wide.data)



