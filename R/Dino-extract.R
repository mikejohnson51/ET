extractXLSX = function(dir = NULL){

files = list.files(dir, full.names = T)
names = list.files(dir)

names = substr(names, 1, 6)

means = NULL

for(i in seq_along(files)){

d1 = xlsx::read.xlsx(files[i], sheetIndex = 1)
means = cbind(means, d1$MAX[1:16]*.1)
}

means = cbind(d1$VALUE[1:16], means)

colnames(means) = c("LC", names)
return(means)

}


PET = extractXLSX(dir ="/Users/mikejohnson/Desktop/PET_2017")
AET = extractXLSX("/Users/mikejohnson/Desktop/AET_2017")


LCc = (AET[,-1]) / PET[,-1]
t(rowMeans(LCc))
max(PET)



par(mfrow = c(4,4))
for(i in 1:16){
plot(PET[i,], type = 'l', col = 'red', )

lines(AET[i,], type = 'l')
}

plot(LCc[7,], type ="l")


max(LCc[7,])
min(LCc[7,])

lc = NULL

for (i in 1:12){

test.p = PET[,substr(colnames(PET),1,2)  == sprintf("%02d", i)]
test.a = AET[,substr(colnames(PET),1,2)  == sprintf("%02d", i)]
test.lc = test.a / test.p

lc = cbind(lc, rowMeans(test.lc))
}


lc = lc[,c(10:12, 1:9)]

rowMeans(test.lc)


plot(lc[4,])
  
  ?substr
#rownames(means) <- d1$VALUE[1:16]
#colnames(means) <- names[1:28]
#

par(mfrow = c(4,4))
for(i in 1:16){
  plot(lc[i,], type = 'l')
}




fin.jul = cbind(fin[,7:23],fin[,1:6])


f1 = xlsx::read.xlsx(files[1], sheetIndex = 1)
f28 = xlsx::read.xlsx(files[28], sheetIndex = 1)

