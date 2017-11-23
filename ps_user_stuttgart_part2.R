## ---- include=FALSE------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,cache=T,warning=F,message=FALSE)
par(mai=c(0,0,0,0))
log_gesis=F
log_home=!log_gesis
  
internet=F
noint = !internet

## ----echo=F,eval=F-------------------------------------------------------
## install.packages("knitr")
## install.packages("sp")
## install.packages("tmap")
## install.packages("choroplethr")
## install.packages("choroplethrMaps")
## install.packages("acs")
## install.packages("rJava")
## install.packages("xlsxjars")
## install.packages("xlsx")

## ----echo=F--------------------------------------------------------------
library(knitr)

## ----echo=F,eval=F-------------------------------------------------------
## setwd("~/GitHub/GeoData/presentations/ps_user_stuttgart")
## purl("ps_user_stuttgart_part3.Rmd")

## ----eval=F,echo=F-------------------------------------------------------
## setwd("D:/Daten/GitHub/GeoData/presentations/ps_user_stuttgart")
## purl("ps_user_stuttgart_part3.Rmd")

## ------------------------------------------------------------------------
library(maps)
map()

## ------------------------------------------------------------------------
map("world", "Germany")

## ------------------------------------------------------------------------
data(world.cities)
map("france")
map.cities(world.cities,col="blue")

## ------------------------------------------------------------------------
library(maptools)
data(wrld_simpl)
plot(wrld_simpl,col="royalblue")

## ----eval=F--------------------------------------------------------------
## head(wrld_simpl@data)

## ----echo=F,eval=noint---------------------------------------------------
kable(head(wrld_simpl@data))

## ----echo=F,eval=internet------------------------------------------------
## library(DT)
## datatable(wrld_simpl@data)

## ------------------------------------------------------------------------
length(wrld_simpl)
nrow(wrld_simpl@data)

## ------------------------------------------------------------------------
ind <- which(wrld_simpl$ISO3=="DEU")

## ------------------------------------------------------------------------
plot(wrld_simpl[ind,])

## ------------------------------------------------------------------------
wrld_simpl@data[ind,]

## ------------------------------------------------------------------------
library(ggplot2);library(choroplethrMaps)
data(country.map)
ggplot(country.map, aes(long, lat, group=group)) 
+ geom_polygon()

## ------------------------------------------------------------------------
data(state.map)
ggplot(state.map,aes(long,lat,group=group))+geom_polygon()

## ----warning=F-----------------------------------------------------------
library(raster)
LUX1 <- getData('GADM', country='LUX', level=1)
plot(LUX1)

## ----eval=F--------------------------------------------------------------
## head(LUX1@data)

## ----eval=T,echo=F-------------------------------------------------------
kable(head(LUX1@data))

## ----eval=F,echo=F-------------------------------------------------------
## datatable(LUX1@data)

## ----eval=F--------------------------------------------------------------
## library(maptools)
## krs <- readShapePoly("vg250_ebenen/vg250_krs.shp")
## plot(krs)

## ----echo=F,eval=log_gesis-----------------------------------------------
## library(maptools)
## krs <- readShapePoly("D:/Daten/Daten/GeoDaten/vg250_ebenen/vg250_krs.shp")

## ----echo=F--------------------------------------------------------------
library(DT)

## ----echo=F,eval=F-------------------------------------------------------
## datatable(krs@data)

## ------------------------------------------------------------------------
head(krs@data$RS)

## ------------------------------------------------------------------------
BLA <- substr(krs@data$RS,1,2)
plot(krs[BLA=="08",])

## ----echo=F,eval=log_gesis-----------------------------------------------
## setwd("D:/Daten/Daten/GeoDaten/")

## ----echo=F,eval=log_home------------------------------------------------
setwd("D:/GESIS/Vorträge/20171122_userStuttgart/data/")

## ----eval=F,echo=F-------------------------------------------------------
## install.packages("maptools")

## ----eval=log_gesis,echo=F-----------------------------------------------
## library(maptools)
## setwd("D:/Daten/Daten/GeoDaten/")
## onb <- readShapePoly("onb_grenzen.shp")

## ----eval=log_home,echo=F------------------------------------------------
library(maptools)
setwd("D:/GESIS/Vorträge/20171122_userStuttgart/data/")
onb <- readShapePoly("ONB_BnetzA_DHDN_Gauss3d-3.shp")

## ----eval=F--------------------------------------------------------------
## onb <- readShapePoly("onb_grenzen.shp")

## ----eval=F--------------------------------------------------------------
## head(onb@data)

## ----eval=noint,echo=F---------------------------------------------------
kable(head(onb@data))

## ----eval=internet,echo=F------------------------------------------------
## datatable(onb@data)

## ----eval=log_gesis------------------------------------------------------
## vwb <- as.character(onb@data$VORWAHL)
## vwb1 <- substr(vwb, 1,2)
## vwb7 <- onb[vwb1=="07",]
## plot(vwb7)

## ----eval=log_home,echo=F------------------------------------------------
vwb <- as.character(onb@data$ONB_NUMMER)
vwb1 <- substr(vwb, 1,1)
vwb7 <- onb[vwb1=="7",]
plot(vwb7)

## ------------------------------------------------------------------------
library(rgdal)

## ----eval=log_gesis,echo=F-----------------------------------------------
## setwd("D:/Daten/Daten/GeoDaten")
## PLZ <- readOGR ("post_pl.shp","post_pl")

## ----eval=log_home,echo=F------------------------------------------------
setwd("D:/GESIS/Workshops/GeoDaten/data/")
PLZ <- readOGR ("post_pl.shp","post_pl")

## ----eval=F--------------------------------------------------------------
## library(rgdal)
## PLZ <- readOGR ("post_pl.shp","post_pl")

## ------------------------------------------------------------------------
SG <- PLZ[PLZ@data$PLZORT99=="Stuttgart",]
plot(SG,col="chocolate1")

## ------------------------------------------------------------------------
BE <- PLZ[PLZ@data$PLZORT99%in%c("Berlin-West",
              "Berlin (östl. Stadtbezirke)"),]
plot(BE,col="chocolate2",border="lightgray")

## ------------------------------------------------------------------------
library(sp)
spplot(wrld_simpl,"POP2005")

## ----eval=F,echo=F-------------------------------------------------------
## install.packages("colorRamps")

## ------------------------------------------------------------------------
library(colorRamps)
spplot(wrld_simpl,"POP2005",col.regions=blue2red(100))

## ------------------------------------------------------------------------
spplot(wrld_simpl,"POP2005",col.regions=matlab.like(100))

## ------------------------------------------------------------------------
library(choroplethr)
data(df_pop_state)

## ----eval=F--------------------------------------------------------------
## head(df_pop_state)

## ----echo=F,eval=internet------------------------------------------------
## datatable(df_pop_state)

## ----echo=F,eval=noint---------------------------------------------------
kable(head(df_pop_state))

## ------------------------------------------------------------------------
state_choropleth(df_pop_state)

## ------------------------------------------------------------------------
state_choropleth(df_pop_state,
                 title      = "2012 Population Estimates",
                 legend     = "Population",num_colors = 1,
                 zoom       = c("california", "washington",
                                "oregon"))

## ------------------------------------------------------------------------
data(df_pop_county)
county_choropleth(df_pop_county)

## ------------------------------------------------------------------------
data(df_pop_country)
country_choropleth(df_pop_country,
              title      = "2012 Population Estimates",
              legend     = "Population",num_colors = 1,
              zoom       = c("austria","germany",
                             "poland", "switzerland"))

## ------------------------------------------------------------------------
library(WDI) 
WDI_dat <- WDI(country="all",
    indicator=c("AG.AGR.TRAC.NO",
    "TM.TAX.TCOM.BC.ZS"),
    start=1990, end=2000)

## ----eval=F--------------------------------------------------------------
## head(WDI_dat)

## ----eval=noint,echo=F---------------------------------------------------
kable(head(WDI_dat))

## ----eval=internet,echo=F------------------------------------------------
## datatable(WDI_dat)

## ------------------------------------------------------------------------
choroplethr_wdi(code="SP.DYN.LE00.IN", year=2012,
                title="2012 Life Expectancy")

## ----echo=F,eval=log_gesis-----------------------------------------------
## setwd("J:/Work/Statistik/Kolb/Workshops/2015/Spatial_MA/Folien/dataImport/data/")

## ----eval=T--------------------------------------------------------------
library(xlsx)
HHsr <- read.xlsx2("data/HHsavingRate.xls",1)

## ----echo=F,eval=T-------------------------------------------------------
kable(HHsr[1:8,1:6])

## ----eval=F,echo=F-------------------------------------------------------
## library(xlsx)
## setwd("D:/GESIS/Vorträge/20171122_userStuttgart/data/")
## bev_dat <- read.xlsx("xlsx_Bevoelkerung.xlsx",3)

## ------------------------------------------------------------------------
zen <- read.csv2("data/Zensus_extract.csv")
# Personen mit eigener Migrationserfahrung
# mit beidseitigem Migrationshintergrund
zen2 <- data.frame(Personen_Mig=zen[,which(zen[9,]==128)],
                   Personen_Mig_bs=zen[,which(zen[9,]==133)])

## ---- eval=F,echo=F------------------------------------------------------
## library(knitr)
## kable(head(bev_dat))

## ----eval=F--------------------------------------------------------------
## url <- "https://raw.githubusercontent.com/Japhilko/
## GeoData/master/2015/data/whcSites.csv"
## 
## whcSites <- read.csv(url)

## ----echo=F--------------------------------------------------------------
url <- "https://raw.githubusercontent.com/Japhilko/GeoData/master/2015/data/whcSites.csv"

whcSites <- read.csv(url) 

## ----echo=F--------------------------------------------------------------
kable(head(whcSites[,c("name_en","date_inscribed","longitude","latitude","area_hectares","category","states_name_fr")]))

## ------------------------------------------------------------------------
ind <- match(HHsr$geo,wrld_simpl@data$NAME)
ind <- ind[-which(is.na(ind))]

## ------------------------------------------------------------------------
EUR <- wrld_simpl[ind,]

## ------------------------------------------------------------------------
EUR@data$HHSR_2012Q3 <- as.numeric(as.character(HHsr[-(1:2),2]))
EUR@data$HHSR_2015Q2 <- as.numeric(as.character(HHsr[-(1:2),13]))

## ------------------------------------------------------------------------
spplot(EUR,c("HHSR_2012Q3","HHSR_2015Q2"))

## ----eval=T,echo=T-------------------------------------------------------
(load("data/info_bar_Berlin.RData"))

## ----echo=F--------------------------------------------------------------
info_be <- info[,c("addr.postcode","addr.street","name","lat","lon")]

## ----echo=F--------------------------------------------------------------
kable(head(info_be))

## ----eval=F--------------------------------------------------------------
## devtools::install_github("Japhilko/gosmd")

## ----eval=F--------------------------------------------------------------
## library("gosmd")
## pg_MA <- get_osm_nodes(object="leisure=playground","Mannheim")
## pg_MA <- extract_osm_nodes(pg_MA,value='playground')

## ------------------------------------------------------------------------
tab_plz <- table(info_be$addr.postcode)

## ------------------------------------------------------------------------
ind <- match(BE@data$PLZ99_N,names(tab_plz))
ind

## ------------------------------------------------------------------------
BE@data$num_plz <- tab_plz[ind]

## ----eval=F,echo=F-------------------------------------------------------
## install.packages("colorRamps")
## install.packages("XML")
## install.packages("geosphere")
## install.packages("tmap")
## install.packages("curl")
## install.packages("R.oo")

## ------------------------------------------------------------------------
library(tmap)

## ------------------------------------------------------------------------
BE@data$num_plz[is.na(BE@data$num_plz)] <- 0
qtm(BE,fill = "num_plz")

## ------------------------------------------------------------------------
load("data/osmsa_PLZ_14.RData")

## ----echo=F--------------------------------------------------------------
dat_plz <- PLZ@data
kable(head(dat_plz))

## ----echo=F--------------------------------------------------------------
PLZ_SG <- PLZ[PLZ@data$PLZORT99=="Stuttgart",]

## ------------------------------------------------------------------------
qtm(PLZ_SG,fill="bakery")

## ------------------------------------------------------------------------
kable(PLZ_SG@data[which.max(PLZ_SG$bakery),c("PLZ99","lat","lon","bakery")])

## ----eval=F,echo=F-------------------------------------------------------
## install.packages("RDSTK")

## ------------------------------------------------------------------------
library("RDSTK")

## ------------------------------------------------------------------------
PLZ_SG <- PLZ[PLZ@data$PLZORT99=="Stuttgart",]

## ----echo=F--------------------------------------------------------------
tab_landcover <- table(PLZ_SG$land_cover.value)
df_landcover <- data.frame(tab_landcover)
colnames(df_landcover)[1] <- c("Type_landcover")
kable(df_landcover)

## ------------------------------------------------------------------------
qtm(PLZ_SG,fill="land_cover.value")

## ------------------------------------------------------------------------
qtm(PLZ_SG,fill="elevation.value")

## ----eval=F--------------------------------------------------------------
## devtools::install_github("dkahle/ggmap")
## install.packages("ggmap")

## ------------------------------------------------------------------------
library(ggmap)

## ----message=F,eval=F----------------------------------------------------
## qmap("Stuttgart")

## ----message=F,eval=F----------------------------------------------------
## qmap("Germany")

## ----message=F,eval=F----------------------------------------------------
## qmap("Germany", zoom = 6)

## ----echo=F--------------------------------------------------------------
# https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/ggmap/ggmapCheatsheet.pdf

## ----message=F,eval=F----------------------------------------------------
## WIL <- qmap("Wilhelma",zoom=20, maptype="satellite")
## WIL

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart Hauptbahnhof', zoom = 15, maptype="hybrid")

## ----message=F,cache=T,eval=F--------------------------------------------
## qmap('Stuttgart Fernsehturm', zoom = 14,
##  maptype="terrain")

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart', zoom = 14,
##  maptype="watercolor",source="stamen")

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart', zoom = 14,
##  maptype="toner",source="stamen")

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart', zoom = 14,
##  maptype="toner-lite",source="stamen")

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart', zoom = 14,
##  maptype="toner-hybrid",source="stamen")

## ----message=F,eval=F----------------------------------------------------
## qmap('Stuttgart', zoom = 14,
##  maptype="terrain-lines",source="stamen")

## ----message=F,eval=T,warning=F------------------------------------------
library(ggmap)
geocode("Stuttgart")

## ----echo=F,message=F,warning=F------------------------------------------
MAgc <- geocode("Stuttgart Wormser Str. 15")
kable(MAgc)

## ----cache=T,message=F---------------------------------------------------
revgeocode(c(48,8))

## ----message=F-----------------------------------------------------------
mapdist("Marienplatz Stuttgart","Hauptbahnhof Stuttgart")

## ----message=F-----------------------------------------------------------
mapdist("Marienplatz Stuttgart","Hauptbahnhof Stuttgart",mode="walking")

## ----message=F-----------------------------------------------------------
mapdist("Marienplatz Stuttgart","Hauptbahnhof Stuttgart",mode="bicycling")

## ----message=F,warning=F-------------------------------------------------
POI1 <- geocode("B2, 1 Mannheim",source="google")
POI2 <- geocode("Hbf Mannheim",source="google")
POI3 <- geocode("Mannheim, Friedrichsplatz",source="google")
ListPOI <-rbind(POI1,POI2,POI3)
POI1;POI2;POI3

## ----message=F,warning=F,eval=F------------------------------------------
## MA_map +
## geom_point(aes(x = lon, y = lat),
## data = ListPOI)

## ----message=F,warning=F,eval=F------------------------------------------
## MA_map +
## geom_point(aes(x = lon, y = lat),col="red",
## data = ListPOI)

## ----eval=F--------------------------------------------------------------
## ListPOI$color <- c("A","B","C")
## MA_map +
## geom_point(aes(x = lon, y = lat,col=color),
## data = ListPOI)

## ----eval=F--------------------------------------------------------------
## ListPOI$size <- c(10,20,30)
## MA_map +
## geom_point(aes(x = lon, y = lat,col=color,size=size),
## data = ListPOI)

## ----message=F,warning=F,cache=T,eval=F----------------------------------
## from <- "Mannheim Hbf"
## to <- "Mannheim B2 , 1"
## route_df <- route(from, to, structure = "route")

## ----message=F,warning=F,cache=T,eval=F----------------------------------
## qmap("Mannheim Hbf", zoom = 14) +
##   geom_path(
##     aes(x = lon, y = lat),  colour = "red", size = 1.5,
##     data = route_df, lineend = "round"
##   )

## ----ggmap_citycenter----------------------------------------------------
library(ggmap)
lon_plz <- PLZ_SG@data[which.max(PLZ_SG$bakery),"lon"]
lat_plz <- PLZ_SG@data[which.max(PLZ_SG$bakery),"lat"]
mp_plz <- as.numeric(c(lon_plz,lat_plz))
qmap(location = mp_plz,zoom=15)

## ------------------------------------------------------------------------
library(osmar) 

## ----eval=F--------------------------------------------------------------
## src <- osmsource_api()
## gc <- geocode("Stuttgart-Degerloch")
## bb <- center_bbox(gc$lon, gc$lat, 800, 800)
## ua <- get_osm(bb, source = src)
## plot(ua)

## ----echo=F--------------------------------------------------------------
load("data/ua_SG_cc.RData")
plot(ua)

## ------------------------------------------------------------------------
bg_ids <- find(ua, way(tags(k=="building")))
bg_ids <- find_down(ua, way(bg_ids))
bg <- subset(ua, ids = bg_ids)
bg_poly <- as_sp(bg, "polygons")  
plot(bg_poly)

