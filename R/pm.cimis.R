pm.cimis = function(Tair = NULL, vp = NULL, Rnet = NULL, wind = NULL) {
  
  message("Starting!")
  es = .6108 * exp((17.27 * Tair) / (Tair + 237.3))
  message("'es' determined (1/8)")
  
  VPD = es - vp #,*.001
  message("'VPD' determined (2/8)")
  
  DEL = (4009*es) / ((Tair + 273.3)*(Tair + 273.3))
  message("'DEL' determined (3/8)")
  
  P = 101.325
  
  #101.325-(0.0115*elev) + (5.44e-7 *elev^2)
  
  GAM = .000646 * (1 + .000946 * Tair) * P
  message("'GAM' determined (4/8)")
  
  W = DEL / (DEL + GAM)
  message("'W' determined (5/8)")
  
  FU2 = 0.030 + 0.0576 * wind #* 0.277778
  message("'FU2' determined (6/8)")
  
  NR = Rnet / (694.5 * (1-.000946 * Tair))
  message("'NR' determined (7/8)")
  
  RET = W * NR + ( (1-W)* VPD * FU2 )
  message("'PET' determined (8/8)")
  
  return(RET)
  
}
