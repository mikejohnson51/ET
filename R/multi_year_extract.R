#' Mutli MODIS year extraction
#'
#' @param dir the directory to all files
#' @param years the years to be processed
#' @param type specify whether you want AET or PET
#'
#' @return
#' @export

multi_year_extract = function(dir, years, type){

  vals = NULL

  for(i in seq_along(years)){

    path = paste0(dir,type, '_', years[i])
    tmp = extractXLSX_modis(dir = path)
    if(i  == 1){ vals =  tmp } else{
      vals = cbind(vals, tmp[,-c(1:4)])
    }
  }

  return(vals)
}
