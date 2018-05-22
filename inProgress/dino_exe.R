AET = multi_year_extract(dir = '/Users/mikejohnson/Desktop/ZIPS/',
                         years = c(2011:2012),
                         type = "AET")

PET = multi_year_extract(dir = '/Users/mikejohnson/Desktop/ZIPS/',
                         years = c(2011:2012),
                         type = "PET")

kc = AET[,-c(1:4)]/PET[,-c(1:4)]

test = agg.monthly(kc, stat = 'mean')




agg.monthly = function(data, stat = 'max'){

vals = NULL

if(stat == "mean"){
for(i in 1:12){
  tmp = rowMeans(data[,substring(names(data),2,3) == sprintf("%02d", i)])
  vals = cbind(vals, tmp)
}
}

if(stat == "max"){
for(i in 1:12){
  tmp = apply(data[,substring(names(data),2,3) == sprintf("%02d", i)], 1, max)
  vals = cbind(vals, tmp)
}
}

colnames(vals) = paste0(month.abb)

return(vals)
}

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





