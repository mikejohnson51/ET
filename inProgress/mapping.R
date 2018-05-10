library(USAboundariesData)
library(USAboundaries)
library(sf)
library(sp)
library(RColorBrewer)





mapStats = function(data)

load("data/watersheds.rda")

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
