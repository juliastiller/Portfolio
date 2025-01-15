# Load libraries
library(readr)

# Read in the .csv file
statcast_pitch_swing_data_20240402_20241030_with_arm_angle <- read_csv("Raw-Data/statcast_pitch_swing_data_20240402_20241030_with_arm_angle.csv")

# Save as Rawdata.rds to be used in PrepData.R
saveRDS(statcast_pitch_swing_data_20240402_20241030_with_arm_angle, "Rawdata.rds")
