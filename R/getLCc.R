#' Get Land Cover Coeffieicentes from MODIS data
#'
#' @param PET (data.frame) A data frame of PET values
#' @param AET (data.frame) A data frame of AET values
#' @param timestep (character) timestep to aggregate to: option include 'raw' (default), 'month', 'all'
#'
#' @return dataframe
#' @export
#'
#' @examples
#'

getLCc = function(PET = NULL,
                  AET = NULL,
                  timestep = "raw") {

  pet = PET[, !(names(PET) %in% names(col_lc))]
  aet = AET[, !(names(AET) %in% names(col_lc))]

  LCa = aet / pet

  if (timestep == "month") {
    LCm = NULL
    for (i in 1:12) {
      tmp = LCa[, substr(colnames(LCa), 1, 2)  == sprintf("%02d", i)]
      LCm = cbind(LCm, rowMeans(tmp))
    }
    LCa = LCm
  }

  if (timestep == "all") {
    LCy = data.frame(
      mean = apply(LCa, 1, mean),
      sd = apply(LCa, 1, sd),
      max = apply(LCa, 1, max),
      min = apply(LCa, 1, min)
    )

    LCa = LCy

  }

  fin = cbind(PET[, (names(PET) %in% names(col_lc))], LCa)
  return(fin)
}
