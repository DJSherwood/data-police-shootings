## Import Libraries


df <- read.csv(
        file = paste0(getwd(),"/fatal-police-shootings-data.csv"),
        header = TRUE,
        sep = ",",
        strip.white = TRUE 
)