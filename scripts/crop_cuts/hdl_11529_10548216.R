 remotes::install_github("reagro/carobiner")
 
# R script for "carob"

## ISSUES
# ....

path <-setwd (".")

carob_script <- function(path) {
  
  "
	Description:
	Crop cut data collected by CSA in 2015 from 382 fields in West Showa, South West Showa, East and West Wollega, Jimma, Iliababur, East Showa, West and East Gojjam. Name of enumerator, name of farmer, gender, field coordinates (longitude, latitude, altitude), type of maize variety, name of variety, fertilizer use, fertilizer types, quantity (organic/inorganic), GPS location of the quadrant, number of crop stand, number of cobs, field weight of sub-samples, grain weight of sub-sample, weight of remaining cobs, field area (2016)."
  
  uri <- "hdl:11529/10548216"
  
  dataset_id <- carobiner::simple_uri(uri)
  group <- "crop-cuts"
  
  ## dataset level metadata 
  dset <- data.frame(
    dataset_id = dataset_id,
    group=group,
    uri=uri,
    project="TAMASA Ethiopia Baseline survey_CSA_ 2015",	   
    publication="T.Balemi and M. Kebede. 2015. Location specific Baseline Survey dataset collected by CSA in Ethiopia",
    data_citation = 'Mesfin Kebede, 2019, "TAMASA Ethiopia Baseline survey_CSA_ 2015", https://hdl.handle.net/11529/10548216, CIMMYT Research Data & Software Repository Network, V2, UNF:6:+Vq4sw4EaWa5KNnkoYu8VA== [fileUNF]',
    data_institutions = "CIMMYT",
    carob_contributor="Layal Atassi",
    carob_date="2024-06-04",
    data_type="survey"
  )
  
  
 ## download data 
  
  ff  <- carobiner::get_data(uri, path, group)
  js <- carobiner::get_metadata(dataset_id, path, group, major=2, minor=1)
  dset$license <- carobiner::get_license(js)
  dset$title <- carobiner::get_title(js)
  dset$authors <- carobiner::get_authors(js)
  dset$description <- carobiner::get_description(js) 
  
  
  #read the data file
  
 
  f <- ff[basename(ff) == "ET_Baseline_CSA_2015.xls"]
  r <- carobiner::read.excel(f, sheet = "Revised_data", n_max = 1738)
  
  
  
  # Add columns and change the columns names
  
  d <- carobiner::change_names(r, c("latitude","longitude", "altitude","Name.of.variety", "Fertilizer.type.organic", "Field.weight.of.remaining.grain..kg.16m2.", "Moisture.adjusted.grain..yield..kg..ha.", "Field.area..ha.", "Carbon....", "pH", "Al..mg.kg.", "Ca...mg.kg.", "EC.S..dS.m.", "S...mg.kg.", "Mn...mg.kg.", "P...mg.kg.", "Zn...mg.kg.", "K...mg.kg.", "Mg...mg.kg." , "Na...mg.kg.", "Fe...mg.kg.", "Boron...mg.kg."), 
                               c("latitude","longitude", "elevation","variety","OM_used","residue_yield", "yield", "plot_area", "soil_SOC", "soil_pH", "soil_Al", "soil_Ca", "soil_EC", "soil_S", "soil_Mn", "soil_P_total", "soil_Zn", "soil_K", "soil_Mg", "soil_Na", "soil_Fe", "soil_B" ))
  
  
  
  #### about the data #####
  
  d$on_farm <- FALSE
  d$is_survey <- TRUE
  d$irrigated <- FALSE
  
  ##### Location #####
  d$dataset_id <- dataset_id
  d$country <- "Ethiopia"
  d$adm1 <- "Oromia, Amhara"
  d$adm2 <- "Jimma, Wollega, West Showa, East Showa, Gojjam"
  d$date <- "2015"
  d$crop <- "Maize"
   
  
  # yield...Unit correction from kg.16m2 to kg/ha
  d$residue_yield <- d$residue_yield * 16000
  
  
  d1 <- d[,c("date","dataset_id","country","adm1","adm2","latitude","longitude","elevation","on_farm","is_survey","irrigated","crop","variety",
             "OM_used","residue_yield", "yield", "plot_area", "soil_SOC", "soil_pH", "soil_Al", "soil_Ca", "soil_EC", "soil_S", "soil_Mn", "soil_P_total",
             "soil_Zn", "soil_K", "soil_Mg", "soil_Na", "soil_Fe", "soil_B")]   
  
  
  
  # all scripts must end like this
  carobiner::write_files(dset, d1, path=path)
  
  
  
   
}
  
  
  
  
  