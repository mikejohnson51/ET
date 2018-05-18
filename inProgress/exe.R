data = as.data.frame(read.csv("/Users/Mike/Desktop/killme3/BasRef2.csv"))
yearsOI = 1939:2009

data = data[data$YEAR %in% yearsOI, ]

stations = as.character(unique(data$GAGE_ID))


str.data = getStationData(data = data, stationID = stations, timestep = 'annual', WaterYear = F)

SAVE = lmStats(x ='ET', y ="PPT", stationData = str.data)
#plotData(str.data, SAVE, save.path = "/Users/Mike/Desktop/jeremy_images")


fin = filterStations(str.data,SAVE,"r2", .5)


names(fin) %in%




mean(SAVE$r2, na.rm = T)

test = aggregate(. ~ DECADE, data = str.data[[2]], FUN = mean )

mod = lm(ET ~ TMAX, data = fin[[1]])
summary(mod)
summary(lm(mod$residuals ~ str.data[[1]]$TMIN))



par(mfrow = c(3,2))
plot(str.data[[1]]$PPT, type = 'l', main = "PPT")
  lines(rollmean(str.data[[1]]$PPT, 10, fill=NA), col = 'blue')
plot(str.data[[1]]$TMAX, type = 'l', main = "TMAX")
  lines(rollmean(str.data[[1]]$TMAX, 10, fill=NA), col = 'blue')
plot(str.data[[1]]$TMIN, type = 'l', main = "Tmin")
  lines(rollmean(str.data[[1]]$TMIN, 10, fill=NA), col = 'blue')
plot(str.data[[1]]$Q, type = 'l', main = "Q")
  lines(rollmean(str.data[[1]]$Q, 10, fill=NA), col = 'blue')
plot(str.data[[1]]$ET, type = 'l', main = "ET")
  lines(rollmean(str.data[[1]]$ET, 10, fill=NA), col = 'blue')
plot(str.data[[1]]$ET.P, type = 'l', main = "ET.P")
  lines(rollmean(str.data[[1]]$ET.P, 10, fill=NA), col = 'blue')

library(zoo)

corrplot::corrplot(cor(str.data[[1]][, 4:8]))
dev.off()

cor(str.data[[3]][, 4:8])

data1 = str.data[[2]]

summary(lm(ET ~ TMAX + TMIN + PPT, data = data1))

summary(lm(ET.P ~ TMAX + TMIN, data = data1))

summary(lm(ET ~ TMAX, data = data1))


dev.off()

load("data/watersheds.rda")
getwd()
