#' Filter statistics by crtieria
#'
#' @param data a data.frame - or list of data.frames - for stations obtained with \code{getStationdata()}
#' @param stats.data a data.frame of statistics returned from \code{lmStats()}
#' @param statistic what statistic are you filtering by? Must match column name in 'stats.data'
#' @param criteria what is the threshold of interest?
#' @param meet (logical) if TRUE returns all station above criteria, else returns all stations below criteria
#'
#' @return a data.frame of stations
#' @export
#'
#' @examples
filterStations = function(data, stats.data, statistic, criteria, meet = TRUE) {

  bad.stations = data[names(data) %in% stats.data[stats.data[, statistic] < criteria,]]$ID
  good.stations = data[names(data) %in% stats.data[stats.data[, statistic] >= criteria,]]$ID

  if (isTRUE(meet)) {
    return(good.stations)
  } else {
    return(bad.stations)
  }

}
