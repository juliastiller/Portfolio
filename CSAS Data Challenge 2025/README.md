# 625-Capstone-Alan-Julia

# MLB Pitch-Level Statcast Data Analysis: CSAS 2025 Data Challenge

## Overview

This repository contains the code and materials for our analysis of MLB pitch-level data from the 2024 season, conducted as part of the CSAS 2025 Data Challenge. Our goal is to model offensive production to help batters determine the optimal conditions for swinging or not swinging, based on contextual factors like count, outs, and batter-pitcher combinations. By integrating new Statcast metrics such as bat speed and swing length, we aim to advance the understanding of hitter decision-making and improve offensive strategies.

## Files

### `ExecutiveSummary.Rmd`
- **Description**: Contains the high-level summary of the project, including key findings and implications.

### `Main.R`
- **Description**: The primary script to run the entire analysis pipeline, including data preparation, exploratory analysis, and model building.

### `ObtainData.R`
- **Description**: Script to obtain the raw data from the 2025 CSAS Data Challenge and prepare it for preprocessing.

### `PrepData.R`
- **Description**: Script for cleaning and preprocessing the raw data, including handling missing values and dropping empty columns.

### `Analysis.R`
- **Description**: Script that contains the data exploration, visualizations, model training and analysis.

### `Rawdata.rds`
- **Description**: Serialized R object containing the raw data extracted from the provided csv dataset for the 2024 MLB season.

### `Report.Rmd`
- **Description**: Main report file, contains abstract detailed methodology, results, and interpretations of the analysis.

### `Report.pdf`
- **Description**: Knitted PDF version of the final report for submission
