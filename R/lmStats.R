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

lmStats = function(y, x, stationData = NULL, residuals = FALSE) {

  if(!(class(stationData) == 'list')){ stationData = list(stationData)}
  stats = NULL
  ID = NULL

  for (i in 1:length(stationData)) {
    mod  = lm(stationData[[i]][, y] ~ stationData[[i]][, x])

    if(residuals){
      stationData[[i]]$resid = mod$residuals
    }

    coef = mod$coefficients[2]
    r2 = summary(mod)$adj.r.squared
    f = summary(mod)$fstatistic
    p <- pf(f[1], f[2], f[3], lower.tail = F)

    ID = append(ID, stationData[[i]]$GAGE_ID[1])

    stats = rbind(stats, as.numeric(c(coef, r2, p)))
  }

  if(residuals){
    return(stationData)
    } else {
  colnames(stats) = c("coeff", "r2", "p")
  stats = as.data.frame(stats, stringsAsFactors = F, row.names = NULL)

  if(length(ID) > 0) { stats$ID = ID }

  return(stats)
  }
}

