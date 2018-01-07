library(maps)
map()

par(mai=c(0,0,0,0))
map()
?par
getwd()
dir()
library(raster)
LUX1 <- getData('GADM', country='LUX', level=1)
plot(LUX1)
Jan

vwb7 <- onb[vwb1=="07",]
vwb7 <- onb[vwb1 %in% c("07","08"),]

library(maptools)
data("wrld_simpl")

head(wrld_simpl@data)

plot(wrld_simpl[wrld_simpl@data$REGION==19,])

table(wrld_simpl@data$REGION)

Jan-Philipp.Kolb@gesis.org

