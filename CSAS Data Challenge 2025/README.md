# CSAS Data Challenge 2025

# MLB Pitch-Level Statcast Data Analysis

## Overview

This repository contains the code and materials for our analysis of MLB pitch-level data from the 2024 season, conducted as part of the CSAS 2025 Data Challenge. Our goal is to model offensive production to help batters determine the optimal conditions for swinging or not swinging, based on contextual factors like count, outs, and batter-pitcher combinations. By integrating new Statcast metrics such as bat speed and swing length, we aim to advance the understanding of hitter decision-making and improve offensive strategies.

## Files

### `Main.R`
- **Description**: The primary script to run the entire analysis pipeline, including data preparation, exploratory analysis, and model building. A folder titled "Raw-Data" must be added to your local environment containing the Data Challenges' CSV file in order to run the scripts.

### `ObtainData.R`
- **Description**: Script to obtain the raw data for the 2025 CSAS Data Challenge and prepare it for preprocessing.

### `PrepData.R`
- **Description**: Script for cleaning and preprocessing the raw data, including handling missing values and dropping empty columns.

### `Analysis.R`
- **Description**: Script that contains the data exploration, visualizations, model training and analysis.

### `Report.Rmd`
- **Description**: Main report file, contains abstract, detailed methodology, results, and interpretations of the analysis.

### `Report.pdf`
- **Description**: Knitted PDF version of the final report for submission.
