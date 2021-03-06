#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

##' @title read_restart.LINKAGES
##' @name  read_restart.LINKAGES
##' @author Ann Raiho \email{araiho@@nd.edu}
##' 
##' @param outdir      output directory
##' @param runid       run ID
##' @param stop.time   year that is being read
##' @param multi.settings    PEcAn settings object
##' @param var.names   var.names to be extracted
##' 
##' @description Read Restart for LINKAGES
##' 
##' @return X.vec      vector of forecasts
##' @export
##' 
read_restart.LINKAGES <- function(outdir, runid, stop.time, settings, var.names = NULL, params = NULL) {
  
  # Read ensemble output
  ens <- read.output(runid = runid, 
                     outdir = file.path(outdir, runid), 
                     start.year = lubridate::year(stop.time), 
                     end.year = lubridate::year(stop.time), 
                     variables = var.names)  # change to just 'AGB' for plot level biomass
  
  # Add PFT name to variable if applicable
  pft.names <- numeric(length(settings$pfts))
  for (i in seq_along(settings$pfts)) {
    pft.names[i] <- settings$pfts[i]$pft$name
  }
  ens.pft.names <- grep("pft", names(ens))
  names(ens[[grep("pft", names(ens))]]) <- pft.names
  
  forecast <- list()

  if ("AGB.pft" %in% var.names) {
    forecast[[1]] <- udunits2::ud.convert(ens$AGB.pft, "kg/m^2", "Mg/ha") #already has C  #* unit.conv 
    names(forecast[[1]]) <- paste0('AGB.pft.',pft.names)
  }
    
  if ("TotSoilCarb" %in% var.names) {
    forecast[[2]] <- udunits2::ud.convert(ens$TotSoilCarb, "kg/m^2", "Mg/ha") #* unit.conv 
    names(forecast[[2]]) <- c("TotSoilCarb")
  }
  
  # Put forecast into vector
  print(runid)
  unlist(forecast)
}
