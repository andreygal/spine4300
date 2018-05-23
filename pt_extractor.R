library(stringr)
library(RSQLite)
options(scipen = 999)

diag_codes <- paste0("dx", sprintf("%02d", c(1:25)))

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
osm <- c(730:739, 73010:73029)
trf <- c(setdiff(80000:82900, as.double(levels(interaction(800:829, 1:9))) * 100),
         as.double(levels(interaction(800:829, 1:9))) * 10)


