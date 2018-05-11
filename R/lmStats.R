#' Get Regression statisitcs for a station
#'
#' @param stationData a data.frame - or list of data.frames - for stations obtained with \code{getStationdata()}
#' @param y a column name to serve as the dependent variable
#' @param x a column name to serve as the independent variable
#'
#' @return a data.frame of statistics for each station and test, including slope coefficenet, R2, and p-value
#' @export
#'
#' @examples


lmStats = function(y, x, stationData = NULL) {
  stats = NULL

  for (i in 1:length(stationData)) {
    mod  = lm(y ~ x, data = stationData[[i]])

    coef = mod$coefficients[2]
    r2 = summary(mod)$adj.r.squared
    f = summary(mod)$fstatistic
    p <- pf(f[1], f[2], f[3], lower.tail = F)


    stats = rbind(stats, c(as.numeric(names(stationData)[i]), coef, r2, p))
  }

  colnames(stats) = c("ID", "coeff", "r2", "p")
  stats = as.data.frame(stats, stringsAsFactors = F, row.names = NULL)

  return(stats)
}

