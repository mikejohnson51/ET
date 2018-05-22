#data = readxl::read_xlsx("/Users/mikejohnson/Desktop/All_Fin_39_2014Area.xlsx")
#yearsOI = 1939:2009
#data = data[data$YEAR %in% yearsOI, ]
#raw = data
#save(raw, file="data/raw_data.rda")

load("data/raw_data.rda")
#stations = as.character(unique(raw$GAGE_ID))
#str.data = getStationData(data = raw, stationID = stations, timestep = 'annual', WaterYear = T)
#save(str.data, file = "data/water_year_data.rda")

load("data/water_year_data.rda")

SAVE = lmStats(x ='PPT', y ="Q", stationData = str.data)

fin = filterStations(str.data,SAVE,"r2", 0)

save2 = lmStats(x ='ET', y ="PPT", stationData = fin, residuals = TRUE)

r2_tmin = NULL
r2_tmax = NULL
type = NULL
r2 = NULL
area = NULL


for(i in 1:length(save2)){

  area = append(area, save2[[i]]$DRAIN_SQKM[1])

  mod = lm( ET ~ PPT , data = save2[[i]])
    test = data.frame(TMIN = save2[[i]]$TMIN, TMAX = save2[[i]]$TMAX, res = mod$residuals, decade = save2[[i]]$DECADE)
    test = aggregate(. ~ decade, data = test, FUN = mean)

    mod_tmin = lm(res ~ TMIN, data = test)
    mod_tmax = lm(res ~ TMAX, data = test)

    r2_tmin = append(r22, summary(mod_tmin)$adj.r.squared)
    r2_tmax = append(r22, summary(mod_tmax)$adj.r.squared)

    if(summary(mod_tmax)$adj.r.squared > summary(mod_tmin)$adj.r.squared) { t = 'tmax'} else {t = "tmin"}

    type = append(type, t)

    if(t == 'tmax') { r = summary(mod_tmax)$adj.r.squared } else {r = summary(mod_tmin)$adj.r.squared }

    r2 = append(r2, r)

}

fin3 = data.frame(ID = names(save2), type = type, r2 = r2, area = area)

fin4 = fin3[fin3$r2 > .15, ]



m = map(fin4)

m



map = function(data = NULL){
  load("data/watersheds.rda")

  data = merge(data, ws, by = 'ID')

  if(!exists("USA")) {
    USA = rgdal::readOGR("/Users/mikejohnson/Downloads/cb_2017_us_nation_20m/cb_2017_us_nation_20m.shp")
  }

  sp = SpatialPointsDataFrame(cbind(data$LONG, data$LAT), data)

  url <- sprintf("https://waterdata.usgs.gov/nwis/inventory/?site_no=%s",
            sp$ID)

  url_call = paste0('<a href=', url, '>', sp$ID, "</a>")

  label <- paste(
    paste("<strong>USGS ID:</strong>", url_call),
    paste("<strong>Area (km2):</strong>", area),
    paste("<strong>R2:</strong>", round(sp$r2, 3)),

    sep = "<br/>"
  )


  m = leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Base") %>%

    addScaleBar("bottomleft") %>%

    addCircleMarkers(lng= sp$LONG, lat = sp$LAT, radius = sp$r2*10, color = ifelse(sp$type == "tmax", "red", "blue"),
                     popup  = label)


  return(m)
}

htmlwidgets::saveWidget(m, file = "ET_v1.html")

mean(fin4$area)
