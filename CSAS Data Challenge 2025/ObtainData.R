# Load libraries
library(readr)

# Read in the .csv file
statcast_pitch_swing_data_20240402_20240630 <- read_csv("Raw-Data/statcast_pitch_swing_data_20240402_20240630.csv")

# Save as Rawdata.rds to be used in PrepData.R
saveRDS(statcast_pitch_swing_data_20240402_20240630, "Rawdata.rds")

# Had option to read in a .arrow file but opted for the .csv file instead