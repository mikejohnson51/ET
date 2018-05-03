#' Aggregate Data by ID
#'
#' @param data (data.frame) a data.frame of values to aggregate
#' @param id (character) the coloumn name to aggregate by
#' @param fun (character) the function to use in aggregation (i.e. mean)
#' @param save.path (character) where should a csv be written to?
#' @param timestep (numeric) number of observations to aggregate
#'
#' @return a data.frame of aggregated values by id
#' @export
#'
#' @examples
#'

aggregateData = function(data,
                         id = NULL,
                         fun = "mean",
                         save.path = TRUE,
                         timestep = 10) {

  # Initialize empty data.frame
  final = NULL

  # Identify unique ids

  stations = unique(data[, id])

  # Run Loop! ---------------------------------------------------------------

  for (i in seq_along(stations)) {
    # Subset each station
    sub = data[data$stn_name == stations[i], ]

    # Determine number of 10 day intervals and create index
    index = rep(1:(nrow(sub) / timestep), each = timestep)

    # Bind index to data
    sub = cbind(sub, index)

    #average by index
    tenDay = aggregate(x = sub$eto_mm,
                       by = list(sub$index),
                       FUN = fun)

    # append to final data.frame
    final = cbind(final, tenDay[, 2])
  }


  # Make it pretty ----------------------------------------------------------

  # name columns
  colnames(final) = stations
  rownames(final) = NULL
  # Add index reference
  final = data.frame(Index = 1:584, final)

  # write to csv
  if(!is.null(save.path)){
    write.csv(final, file = paste0(save.path,"/", timestep, "_day_aggregate.csv"))

  }

  return(final)

}
