# Jan-Philipp Kolb
# Sun Nov 19 09:13:04 2017

library(ggmap)

datapath <- "D:/Daten/GitHub/GeoData/presentations/ps_user_stuttgart/data/"
graphpath <- "D:/Daten/GitHub/GeoData/presentations/ps_user_stuttgart/figure"


stg1 <- qmap("Stuttgart Pragsattel",zoom=15)

setwd(graphpath)
png("ggmap_Stg_Pragsattel.png")
  stg1
dev.off()