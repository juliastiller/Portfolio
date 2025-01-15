# Load libraries
library(tidyverse)

# Read in the .rds file
d = readRDS("Rawdata.rds")

# Examine
head(d)

# Cast d as a dataframe
d = as.data.frame(d)

# Remove deprecated and empty columns
names(d)

d = d %>%
  select(-spin_dir,
        -spin_rate_deprecated,
         -break_angle_deprecated,
         -break_length_deprecated,
         -tfs_zulu_deprecated,
         -tfs_deprecated,
         -umpire,
         -sv_id)

# Drop rows with missing pitch_type/release_speed (~250, likely a data error)
d = d %>%
  filter(!is.na(pitch_type)) %>%
  filter(!is.na(release_speed))

# Now get the na counts for each column
colSums(is.na(d)) #looks good

# Drop the one row that has four balls recorded
d = d %>%
  filter(d$balls != 4)

# Condense the pitch type
d$pitch_category <- case_when(
  d$pitch_type %in% c("CS", "CU", "KC") ~ "Curveball",
  d$pitch_type %in% c("FA", "FF", "SI") ~ "Fastball",
  d$pitch_type %in% c("CH", "FS", "FO") ~ "Offspeed",
  d$pitch_type %in% c("FC", "SL", "ST", "SV") ~ "Breaking balls",
  TRUE ~ "Other"
)
d %>%
  select(pitch_type,
         pitch_name,
         pitch_category) %>%
  unique() %>%
  arrange(pitch_type)
# can drop name and type once category is confirmed

# Last step - save as Data.rds to be used in Analysis.R
saveRDS(d, "Data.rds")
