#' Plot Data from getStationData
#'
#' @param data a data.frame - or list of data.frames - obtained with \code{getStationData}
#' @param stats a data.frame returned from lmStats (optional)
#' @param save.path a folder to save images to (optional)
#' @param clear.folder (logical) if saving images should the folder be cleared before running?
#'
#' @return images
#' @export
#'
#' @examples

plotData = function(data = NULL,
                    stats = NULL,
                    save.path = NULL,
                    clear.folder = TRUE) {
  if (all(!is.null(save.path), isTRUE(clear.folder))) {
    file.remove(list.files(save.path, full.names = T))
  }

  for (i in 1:length(data)) {
    df = data[[i]]
    id = unique(df$GAGE_ID)

    if (!is.null(save.path)) {
      png(
        paste0(save.path, "/img_", id, ".png"),
        width = 16,
        height = 8,
        units = 'in',
        res = 300
      )
    }

    par(mfrow = c(2, 3), mar = c(3, 3, 3, 3))

    plot(
      df$Q,
      pch = 16,
      cex = 1.5,
      main = "Discharge",
      col = "blue"
    )
    plot(
      df$PPT,
      pch = 16,
      cex = 1.5,
      main = "PPT",
      col = "purple"
    )
    plot(
      df$ET,
      pch = 16,
      cex = 1.5,
      main = "ET",
      col = "darkgreen"
    )
    plot(
      df$TMAX,
      pch = 16,
      cex = 1.5,
      main = "Tmax",
      col = "red"
    )
    plot(
      df$ET.P,
      pch = 16,
      cex = 1.5,
      main = "ET/P",
      col = "black"
    )
    plot(
      c(0, 1),
      c(0, 1),
      ann = F,
      bty = 'n',
      type = 'n',
      xaxt = 'n',
      yaxt = 'n'
    )

    if (!is.null(stats)) {
      id = unique(df$GAGE_ID)
      text(
        x = 0.5,
        y = 0.5,
        paste(
          "Station ID:",
          id,
          "\n\n",
          "ET ~ PPT summary:\n\n",
          "Slope Coefficent:",
          round(stats[stats$ID == id, ]$coeff, 2) ,
          "\n",
          "R2:",
          round(stats[stats$ID == id, ]$r2, 2),
          "\n",
          "P-value:",
          round(stats[stats$ID == id, ]$p , 8),
          "\n"
        ),
        cex = 1.6,
        col = "black"
      )
    }
    if (!is.null(save.path)) {
      dev.off()
    }
  }
}
