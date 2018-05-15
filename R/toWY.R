#' To Water Year
#'
#' Convert matrix from calander year to water year
#'
#' @param data data organized with rows of years and columns of monthly values
#'
#' @return
#' @export
#'

toWY = function(data){
  data = c(t(data))
  data = tail(data, -9)
  data = head(data, -3)
  data = as.data.frame(matrix(data, ncol = 12, byrow = T))

  return(data)
}
