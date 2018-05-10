#' Daymet Airports
#'
#' Dataset containing information global Airports subset to the Daymet Domain
#'
#' @docType data
#'
#' @format a \code{dataframe} instance, 1 row per station with columns:
#' \itemize{
#' \item 'OBJECTID':      A \code{character} Object id in the dataset
#' \item 'feature_id':    A \code{character}  NHD COMID of reach
#' \item 'site_no':       A \code{character}      USGS site number
#' \item 'site_name':     A \code{character}    USGS site name
#' \item 'da_sqkm':       A \code{numeric}        Area that drains to the location in square kilometers
#' \item 'lat_reachCent': A \code{numeric}  Latitude of NHD reach center
#' \item 'lon_reachCent': A \code{numeric}  Longitude of NHD reach center
#' }
#'
#' @source Merged OpenFlights Dataset with DAYMET grid
#'
#' @examples
#' \dontrun{
#'  load("daymet_airports.rda")
#' }

"daymet_airports"

#' 2015 Fluxnet stations subset to the Daymet Domain
#'
#' Dataset containing information about USGS stations in the United States
#'
#' @docType data
#'
#' @format a \code{dataframe} instance, 1 row per station with columns:
#' \itemize{
#' \item 'siteid':      A \code{character} Internal database identifier for each site
#' \item 'fluxnetid':    A \code{character}  Site ID within the Fluxnet network
#' \item 'keyid':       A \code{character}     Unknown definition
#' \item 'sitename':       A \code{character}      Human readable site name
#' \item 'country':     A \code{character}    Country location of site
#' \item 'land_unit':       A \code{numeric}       Region location of site
#' \item 'status': A \code{numeric}  Active/inactive status of site as of 2016-03-01
#' \item 'latitude': A \code{numeric}  Latitude coordinate
#' \item 'longitude':      A \code{character} Longitude coordinate
#' \item 'year_began':    A \code{character}  Year the site started collecting data within the FLUXNET framework
#' \item 'network1':       A \code{character}    Current site network
#' \item 'network2':     A \code{character}    Previous site network
#' \item 'network3':       A \code{numeric}       Other previous site network
#' \item 'koeppen_cl': A \code{numeric}  Koppen-Geiger climate classification
#' \item 'igbp_land_': A \code{numeric}  Site land cover (MODIS IGBP classification)
#' \item 'umd_land_c':      A \code{character}Site land cover (MODIS UMD classification)
#' \item 'lai_fpar':    A \code{character}  Site land cover (MODIS LAI/fpar classification)
#' \item 'npp_land_c':       A \code{character}      Site land cover (MODIS NPP classification)
#' \item 'plant_func':     A \code{character}    Unknown definition
#' \item 'TileID':       A \code{numeric}      Underlying DAYMET tile ID
#' }
#'
#' @source Merged NCAR Airport Dataset with DAYMET grid
#'
#' @examples
#' \dontrun{
#'  load("daymet_flux.rda")
#' }

"daymet_flux"

#' Watersheds
#'
#' \code{ws} contains the watershed centroids used in this study
#'
#' @docType data
#'
#' @format a \code{data.frame}
#'
#' @references  Kottek, M., J. Grieser, C. Beck, B. Rudolf, and F. Rubel, 2006:
#' World Map of the Köppen-Geiger climate classification updated. Meteorol. Z., 15, 259-263.
#' DOI: 10.1127/0941-2948/2006/0130.
#'
#' @source \href{http://koeppen-geiger.vu-wien.ac.at/present.htm}{Koppen Climate Data}
#'
#' @examples
#' \dontrun{
#'  load("watersheds.rda")
#' }

"ws"

#' DAYMET Tile Index
#'
#' \code{daymet_tiles} contains the Polygon tile index for DAYMET meterological Data
#'
#' @docType data
#'
#' @format a \code{SpatialPolygonsDataFrame}
#' \itemize{
#' \item 'TileID':  A \code{integer} Tile ID
#' \item 'XMin':    A \code{integer} minimum latitude
#' \item 'XMax':    A \code{integer} maximum latitude
#' \item 'YMin':    A \code{integer} minimum longitide
#' \item 'YMax':    A \code{integer} maximum longitude
#' }
#'
#' @source \href{https://daymet.ornl.gov/gridded.html}{DAYMET Tile Data}
#'
#' @examples
#' \dontrun{
#'  load("daymet_tiles.rda")
#' }

"daymet_tiles"
