library(stringr)
library(RSQLite)
library(data.table)
options(scipen = 999)
setwd('~/Documents/Ortho/')

diag_fields <- noquote(paste0("dx", sprintf("%02d", c(1:25))))
icd9_range_gen <- function(start, end) {
  a <- trunc(start / 100)
  b <- trunc(end / 100)
  codes <- c(setdiff(start:end, as.double(levels(interaction(a:b, 1:9))) * 100),
           as.double(levels(interaction(a:b, 0:9))) * 10)
}

#Exclusion Criteria ICD-9
ocd <- 3003
ssd <- 3008
eds <- 30750:30759
eld <- c(3076, 3077)
sd  <- 30270:30279
dc  <- c(3120:3129, 31210:31290)
sad <- c(3050:3059, 30510:30593)
del <- c(29011, 2903, 2930, 2931, 78009)
pd  <- 3010:3019
osm <- c(7301:7309, 73011:73029)
trf <- icd9_range_gen(80000, 82900)
pfr <- c(7331, 73311:73319)
pcm1 <- icd9_range_gen(14000, 16200)
pcm2 <- icd9_range_gen(16400, 17630)
pcm3 <- icd9_range_gen(16400, 17630)
pcm4 <- icd9_range_gen(19710, 20920)
pcm5 <- icd9_range_gen(20922, 20940)
pcm6 <- icd9_range_gen(23000, 23110)
pcm7 <- icd9_range_gen(23180, 23490)
pcm  <- c(pcm1, pcm2, pcm3, pcm4, pcm5, pcm6, pcm7)
ostp <- c(7330, 73300:73309)
misc <- c(3561, 2775, 7310, 25201, 0150, 034.38, 034.39)
polm <- c(noquote(sprintf("%05d", 04500:004593)), noquote(sprintf("%04d", trunc((4500:4593) / 10))), 138)
ric  <- c(2680, 2681)
tub  <- c(noquote(sprintf("%05d", 01000:01896)), noquote(sprintf("%04d", trunc((1000:1896) / 10))))
sbm  <- icd9_range_gen(74100, 74193)
nrfb <- c(icd9_range_gen(23770, 23772), 23779)
crp  <- c(03438, 03439)
exclus_codes <- noquote(c(ocd, ssd, eds, eld, sd, dc, sad, del, pd, osm, trf, 
                          pfr, pcm, ostp, misc, polm, ric, tub, sbm, nrfb, crp))

#MHD group ICD-9 codes 
sd <- c(78052, 78054, 34701:34709, 3471, 327.23, 327.24,
        327.26, 30745:30747, 33394, 78052, 78054, 78059)
dd <- c(29699, 29621:29626, 2962, 2963, 29631:29636, 3004, 29393, 311)
ad <- c(29384, 3000, 30001:30009, 30022:30029)
sd <- c(3074, 3083, 3090, 30924, 30928, 3093, 30981, 30989, 3099, 31389)
mhd_codes <- c(sd, dd, ad, sd)

#query SPARCS for patients
drv <- dbDriver("SQLite")
con <- dbConnect(drv, 'new_test.db', flags = SQLITE_RO)
query <- "SELECT SUBSTR(dischno, 0 ,5) AS year, *, CAST(age AS INTEGER) AS age
          FROM primrecs
          WHERE dx01 IN (7210, 7220, 7224, 72281, 72291, 7211, 72271) AND
          PR00 IN (8102, 8103, 8132, 8133) AND
          age >= 18 AND
          year BETWEEN '2009' AND '2011';"
patients <- as.data.table(dbGetQuery(con, query))

#remove patients meeting the exclusion criteria 
for(patient in patients) { 
  for(dx_field in diag_fields) {
    if (!(dx_field %in% exclus_codes)
  }
}
 



