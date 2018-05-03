
#' Extract data from MODIS excel files
#'
#' @param dir (character) the path to the XLSX files
#' @param column (character) what column/statistic do you want to extract?
#'
#' @return a data.frame
#' @export
#'
#' @examples

extractXLSX_modis = function(dir = NULL, column = "MAX" ){

  files = list.files(dir, full.names = T)
  names = substr(list.files(dir), 1, 6)

  vals = col_lc

  for(i in seq_along(files)){

    d1 = xlsx::read.xlsx(files[i], sheetIndex = 1)
    max = data.frame(d1[,"VALUE"], d1[,column]*.1)
    colnames(max) = c("code", names[i])
    vals = merge(vals, max, by= 'code', all.x = T)
  }


  vals =  vals[complete.cases(vals), ]


  return(vals)

}

