#' Converts data from Calander year to water year
#'
#' @param data an input matrix where rows are years and columns are months
#'
#' @return
#' @export
#'

toWY = function(data){
  data = c(t(data))
  data = tail(data, -9)
  data = head(data, -3)
  data = as.data.frame(matrix(data, ncol = 12))

  return(data)
}


