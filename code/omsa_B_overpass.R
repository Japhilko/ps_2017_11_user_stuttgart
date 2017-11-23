# Jan-Philipp Kolb
# Mon Sep 05 10:39:16 2016


## ------------------------------------------------------------------------
# install.packages("gsubfn")

library("gsubfn")
library("geosmdata")
library("stringr")

data.path <- "J:/Work/Statistik/Kolb/Paper/OSM_SmallArea/data"

setwd(data.path)

# (load("PLZ_osmsa.RData"))
# (load("osmsa_PLZ_2.RData"))
(load("osmsa_PLZ_13.RData"))

## ------------------------------------------------------------------------
placeL <- c("Baden-WÃ¼rttemberg","ThÃ¼ringen","Bremen","Hamburg","Nordrhein-Westfalen","Rheinland-Pfalz","Hessen","Schleswig-Holstein","Niedersachsen","Mecklenburg-Vorpommern","Brandenburg","Sachsen","Sachsen-Anhalt","Bayern","Saarland","Berlin")
placeLi <- c("Baden-Wuerttemberg","Thueringen","Bremen","Hamburg","Nordrhein-Westfalen","Rheinland-Pfalz","Hessen","Schleswig-Holstein","Niedersachsen","Mecklenburg-Vorpommern","Brandenburg","Sachsen","Sachsen-Anhalt","Bayern","Saarland","Berlin")

## ------------------------------------------------------------------------
keyI <- "amenity"
mfeatures <- c("bar","biergarten","cafe","fast_food","ice_cream","pub","restaurant","college")
## ------------------------------------------------------------------------
keyI <- "shop"
mfeatures <- c("bakery","butcher","department_store","general","kiosk","mall","supermarket","clothes","chemist")
## ------------------------------------------------------------------------
keyI <- "lit"
mfeatures <- c("yes")
## ------------------------------------------------------------------------
keyI <- "traffic_calming"
mfeatures <- c("yes")
## ------------------------------------------------------------------------
keyI <- "highway"
mfeatures <- c("bus_stop","crossing","street_lamp","stop","traffic_signals")
## ------------------------------------------------------------------------
keyI <- "leisure"
mfeatures <- c("common","park","pitch","playground")




## ------------------------------------------------------------------------
for (j in 1:length(placeL)){
  keylist <- data.frame(keyI,mfeatures,placeL[j])
  keylist[,2] <- as.character(keylist[,2])

  for (i in 1:nrow(keylist)){
    if(!file.exists(paste0("info_",keylist[i,2],"_",placeLi[j],".RData"))){

      obj_i <- paste0(keylist[i,1],"=",
                      keylist[i,2])

      pgi <- get_osm_nodes(object=obj_i,keylist[i,3])
      info <- extract_osm_nodes(pgi,keylist[i,2])
      save(info,file=paste0("info_",keylist[i,2],"_",placeLi[j],".RData"))
      saveXML(pgi,file=paste0("pgi_",keylist[i,1],"_",keylist[i,2],"_",placeLi[j],".xml"))
    }
  cat(keylist[i,2],placeLi[j],"\n")
}
}

## ------------------------------------------------------------------------
## Point in polygon

Minfo <- expand.grid(mfeatures,placeLi)
latlon_list <- list()

for (i in 1:nrow(Minfo)){
  DatenM <- paste0("info_",Minfo[i,1],"_",Minfo[i,2],".RData")
  load(DatenM)
  if(!is.null(info)){
    latlon_list[[i]] <- data.frame(lat=info$lat,lon=info$lon,
                                   place=Minfo[i,2],value=Minfo[i,1])

  }
}


latlon_dat <- do.call(rbind,latlon_list)
value_u <- as.character(unique(latlon_dat$value))

for (i in 1:length(value_u)){
  namll <- value_u[i]
  poi <- latlon_dat[latlon_dat$value==namll,]

  coordinates(poi) <- ~ lon + lat
  proj4string(poi) <- proj4string(PLZ)
  ind <- over(poi, PLZ)

  tabind <- tapply(ind$PLZ99_N,ind$PLZ99_N,length)

  tabindi <- match(PLZ@data$PLZ99_N,names(tabind))
  eval(parse(text=paste0("PLZ@data$",
                         namll,"<-tabind[tabindi]")))
  eval(parse(text=paste0("PLZ@data$",
                         namll,"[is.na(PLZ@data$",namll,")]<-0")))
}

save(PLZ,file="osmsa_PLZ_14.RData")



## ------------------------------------------------------------------------
## Point in polygon

dnam <- dir()
dnam2 <- agrep("info",dnam)
dnam3 <- dnam[dnam2]
dnam4 <- gsub("info_","",dnam3)
dnam5 <- gsub(".RData","",dnam4)

ind_dnam1 <- agrep("Koeln",dnam5)
ind_dnam2 <- agrep("_plz",dnam5)
ind_dnam3 <- agrep("revgc",dnam5)
ind_dnam4 <- agrep("revgc2",dnam5)
ind_dnam5 <- agrep("rdstk",dnam5)

ind_dnamAB <- c(ind_dnam1,ind_dnam2,ind_dnam3,ind_dnam4,ind_dnam5)

dnam3b <- dnam3[-ind_dnamAB]
dnam5b <- dnam5[-ind_dnamAB]

ind_mfeatures <- list()
for (i in 1:length(mfeatures)){
  ind_mfeatures[[i]] <- agrep(mfeatures[i],dnam5b)
}

ind_mfeat <- unlist(ind_mfeatures)
dnam3b <- dnam3[ind_mfeat]
dnam5b <- dnam5[ind_mfeat]

# http://stackoverflow.com/questions/12427385/how-to-calculate-the-number-of-occurrence-of-a-given-character-in-each-row-of-a
# Count the number of 'a's in each element of string
num_str <- str_count(dnam5b, "_")

ssplit <- strsplit(dnam5b,"_")


# ergac <- list()
# ergab <- list()
latlon_list <- list()
for (i in 1:length(dnam5b)){
  load(dnam3b[i])
  placI <- ifelse(num_str[i]==1,ssplit[[i]][2],ssplit[[i]][3])
  # ergab[[i]] <- c(i, placI)
  val <- ifelse(num_str[i]==1,ssplit[[i]][1],ssplit[[i]][2])
  # ergac[[i]] <- c(i, val)
  if(!is.null(info)){
    latlon_list[[i]] <- data.frame(lat=info$lat,lon=info$lon,
                                   place=placI,value=val)

  }
}

latlon_dat <- do.call(rbind,latlon_list)

# ergabb <- do.call(rbind,ergab)
# ergabc <- do.call(rbind,ergac)

# save(latlon_dat,file="latlon_dat.RData")

load("latlon_dat.RData")

value_u <- as.character(unique(latlon_dat$value))
value_u <- value_u[-which(value_u%in%c("biergarten","college","store","restaurant",NA,"supermarket"))]

latlon_dat <- latlon_dat[latlon_dat$value%in%value_u,]


for (i in 1:length(value_u)){
  namll <- value_u[i]
  poi <- latlon_dat[latlon_dat$value==namll,]

  coordinates(poi) <- ~ lon + lat
  proj4string(poi) <- proj4string(PLZ)
  ind <- over(poi, PLZ)

  tabind <- tapply(ind$PLZ99_N,ind$PLZ99_N,length)

  tabindi <- match(PLZ@data$PLZ99_N,names(tabind))
  eval(parse(text=paste0("PLZ@data$",
                         namll,"<-tabind[tabindi]")))
  eval(parse(text=paste0("PLZ@data$",
                         namll,"[is.na(PLZ@data$",namll,")]<-0")))
}

save(PLZ,file="osmsa_PLZ_12.RData")

## Links

# https://techoverflow.net/blog/2012/11/10/r-count-occurrences-of-character-in-string/



## AddOn

Info_Trier <- get_osm_nodes(object="amenity=cafe","Trier")

save(Info_Trier,file="pgi_amenity_cafe_Trier.RData")

load("info_cafe_Rheinland-Pfalz.RData")

# http://stackoverflow.com/questions/15253954/replace-multiple-arguments-with-gsub
# dnam4 <- gsubfn(paste0("_",placeLi,".RData"),"",dnam4)

# for ( i in 1:length(placeLi)){
#   dnam4 <- gsub(paste0("_",placeLi[i],".RData"),"",dnam4)
# }
