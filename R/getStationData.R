#' Parse Data from Raw Station Output
#'
#' @param data a csv of RAW PRISM and USGS Flow data
#' @param stationID the station to parse
#' @param timestep timestep to average to: options include 'monthly' and 'annual'
#'
#' @return a list of data.frames, one for each station
#' @export
#'
#' @examples


getStationData = function(data = NULL,
                          stationID = NULL,
                          timestep = "monthly") {
  items = list()

  for (k in seq_along(stationID)) {
    stat.data = data[data$GAGE_ID == stationID[k],]

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


    if (timestep == 'annual') {
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


    if (length(stationID) > 1) {
      items[[paste(stationID[k])]] = fin
    } else {
      items = fin
    }
  }


  return(items)

}
