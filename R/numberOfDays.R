#' Number of Days in a Month
#' 
#' @description Use this function to determine the number of days is a month
#'
#' @param date (date) a single or vector of dates
#'
#' @return the number of days in the month of each date
#' @export
#'
#' @examples
numberOfDays <- function(date) {
  m <- format(date, format = "%m")
  
  while (format(date, format = "%m") == m) {
    date <- date + 1
  }
  
  return(as.integer(format(date - 1, format = "%d")))
}