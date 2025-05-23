# frigatebird-chla-analysis
Using chlorophyll-a data with GPS tracks of frigatebirds using MODIS and ERDDAP in R


# Frigatebird Movement and Chlorophyll-a Integration

This project enriches GPS tracking data of frigatebirds with satellite-derived environmental data—specifically **chlorophyll-a concentration**—to explore the ecological drivers of seabird behavior over time and space. The workflow was developed for training purposes in NASA's ARSET program and is compatible with MODIS Aqua daily chlorophyll datasets accessed via ERDDAP.

---

## Objectives

- Download chlorophyll-a data from the ERDDAP server (MODIS Aqua, daily).
- Match remotely sensed data with animal tracking locations based on space and time.
- Visualize enriched tracks to explore ecological patterns.
- Create a reusable and reproducible workflow using open data and R.

---

## Data Sources

### 1. **Frigatebird Tracking Data**
- Format: `.rds`
- Contents: Cleaned GPS telemetry (timestamp, lat/lon, bird ID)
- Source: Provided externally, not included due to data privacy

### 2. **Chlorophyll-a Concentration**
- Source: MODIS Aqua daily product via ERDDAP
- Dataset ID: `erdMBchlamday_LonPM180`
- Accessed via `rerddap` and `rerddapXtracto` packages

## Workflow Overview

| Step | Description                                                         |
| ---- | ------------------------------------------------------------------- |
| 1    | Load cleaned GPS tracking data                                      |
| 2    | Define spatial and temporal extents                                 |
| 3    | Download and process chlorophyll-a from ERDDAP                      |
| 4    | Create a raster stack of chlorophyll data                           |
| 5    | Match track points to environmental conditions by date and location |
| 6    | Append chlorophyll-a values to each GPS point                       |
| 7    | Save enriched dataset and visualize                                 |


# Output

Map of all frigatebird tracks by individual bird ID

Chlorophyll-a concentration overlaid on a selected track, highlighting productivity zones


# Data Description
## Raw Data Source
All frigatebird tracking data originate from:
Movebank: DataOne Repository – 10.24431/rw1k8ez
This dataset includes GPS tracking of Great Frigatebirds (Fregata minor) in the Pacific Ocean, deployed with E-Obs tags and archived in Movebank

## frigatebird_tracks_cleaned.rds
Description: Cleaned version of the raw GPS data from the Movebank archive.

Contents: A dataframe containing timestamped locations (Timestamp, LocationLat, LocationLong) and metadata (e.g., TagLocalIdentifier).

Processing: Unreliable records with missing or duplicated coordinates were removed; timestamps were formatted into POSIXct. No environmental variables are appended yet.

##  frigatebird_tracks_combined.rds
Description: Combined cleaned GPS datasets from multiple birds into one master file.

Contents: A merged dataset with standardized fields and time zones.

Purpose: Enables cross-individual comparisons or population-level analyses.

##  chlorophyll_download.nc
Description: A NetCDF file containing daily surface chlorophyll-a concentrations across the tracking domain.

Source: MODIS Aqua ocean color product via ERDDAP (erdMBchlamday_LonPM180).

Download Method: Downloaded using the rxtracto_3D() function from rerddapXtracto, using the bounding box and time span of bird movements.

Usage: Serves as the source for extracting chlorophyll-a values at each GPS coordinate.

##  frigatebird_tracks_with_chla_final.rds
Description:
This dataset contains enriched frigatebird tracking data with corresponding chlorophyll-a concentrations extracted from MODIS satellite imagery. Each tracking point includes environmental context based on its location and date.

Contents:
Includes all fields from the cleaned tracking dataset, along with an additional column:

chla – Chlorophyll-a concentration (mg/m³) at each GPS location.

Processing Workflow:
Timestamp Processing:
GPS timestamps were rounded to the first day of each month and stored in the MonthDate column to match the temporal resolution of the chlorophyll dataset.

Satellite Data Matching:
MODIS chlorophyll-a raster layers were selected based on the corresponding MonthDate values.

Spatial Extraction:
For each GPS coordinate, chlorophyll-a values were extracted from the raster layer covering that location and date.

Data Integration:
Extracted chlorophyll-a values were merged into the original track dataset to provide environmental context for movement analysis.



# License

MIT License. See LICENSE.md for details.

# Contact
Developed for NASA ARSET training by Morgan Gilmour

Adapted and maintained by Tanif Howlader
📧 Email: tanifhowlader@trentu.ca

# Acknowledgments
This workflow is based on materials from the NASA ARSET course:
"Introduction to the Integration of Animal Tracking and Remote Sensing (Part 2)"




---

## Required R Packages

```r
library(ggplot2)
library(dplyr)
library(viridis)
library(rerddap)
library(rerddapXtracto)
library(raster)
library(lubridate)
library(sp)


# Install missing packages:
install.packages(c("ggplot2", "dplyr", "viridis", "raster", "lubridate", "sp"))
# Use remotes::install_github() if rerddapXtracto is not on CRAN












