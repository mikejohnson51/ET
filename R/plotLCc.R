#' Plot LCc Values
#'
#' @param LC (data.frame) plot LC values from getLCc
#'
#' @return a plot of LCc value time series
#'
#' @export
#'
#' @examples

plotLCc = function(LC = NULL) {
  lc = as.matrix(LC[, !(names(LC) %in% names(col_lc))])

  info = LC[, (names(LC) %in% names(col_lc))]

  ncol = ceiling(nrow(lc) / 4)
  nrow = ceiling(nrow(lc) / ncol)

  par(mfrow = c(nrow, ncol), mar = c(2, 2, 2, 2))

  for (i in 1:nrow(lc)) {
    plot(
      lc[i, ],
      type = 'o',
      pch = 16,
      main = info$description[i],
      col.main = 'red',
      cex.main = .75,
      axes = F
    )
    axis(1, at = c(1:12), lab = c(1:12))
    axis(2,
         las = 1,
         at = seq(0, 1, .1),
         lab = seq(0, 1, .1))


  }

}
