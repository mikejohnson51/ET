#' Aggregate 8-day MODIS steps to monthly averges
#'
#' @param data the data source to aggregate where columns refer to MODIS dates
#' @param stat the stat to select with. Can be 'mean' or 'max'
#'
#' @return
#' @export

agg.monthly = function(data, stat = 'max'){

  vals = NULL

  if(stat == "mean"){
    for(i in 1:12){
      tmp = rowMeans(data[,substring(names(data),2,3) == sprintf("%02d", i)])
      vals = cbind(vals, tmp)
    }
  }

  if(stat == "max"){
    for(i in 1:12){
      tmp = apply(data[,substring(names(data),2,3) == sprintf("%02d", i)], 1, max)
      vals = cbind(vals, tmp)
    }
  }

  colnames(vals) = paste0(month.abb)

  return(vals)
}
