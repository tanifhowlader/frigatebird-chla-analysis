# **Frigatebird Movement and Environmental Covariates Analysis**

This repository contains the full **analysis workflow** for linking frigatebird GPS tracking data with remotely sensed environmental variables, including **chlorophyll-a concentration** and **bathymetric depth**. The project uses R and open-source spatial packages to understand how marine top predators interact with oceanographic features across the central Pacific Ocean.

---

## 📂 **Repository Structure**

```
frigatebird-analysis/
├── data/
│   ├── frigatebird_tracks_cleaned.rds
│   ├── bathymetry_data.rds
│   ├── chlorophyll_download.nc
│   ├── frigatebird_tracks_with_chla_bathy_final.rds
├── scripts/
│   ├── chlorophyll_extraction.R
│   ├── bathymetry_download.R
│   ├── density_and_ppm_model.R
│   ├── bathymetric_profile_plot.R
├── figures/
│   ├── example_map.png
│   ├── profile_plot.png
├── docs/
│   ├── index.html  # For GitHub Pages
├── README.md
├── LICENSE
├── .gitignore
```

---

## 📜 **Project Description**

This project investigates how **frigatebirds** use marine environments, particularly focusing on their spatial association with:

* **Surface ocean productivity** (via satellite-derived chlorophyll-a)
* **Bathymetric features** (deep trenches, shallow ridges, slopes)

I have used **point process models**, **kernel density estimation**, and **spatial visualizations** to explore habitat use patterns, identify migration corridors, and assess individual variability.

---

## ⚙ **Requirements**

* **R** (≥4.2)
* **R packages**:

  ```r
  install.packages(c("marmap", "spatstat", "sf", "ggplot2", "dplyr", "rerddapXtracto", "ncdf4"))
  ```

---

## 📈 **How to Reproduce**

```bash
# Clone repository
$ git clone https://github.com/tanifhowlader/frigatebird-analysis.git

# Navigate to project directory
$ cd frigatebird-analysis

# Open R and run scripts in /scripts sequentially
```

Outputs (figures, models) will be saved to `/figures`.

---

## 📄 **License**

This project is licensed under the **MIT License** — see the `LICENSE` file for details.

---

## 🌐 **GitHub Pages Site**

The project website is available at:

```
https://tanifhowlader.github.io/frigatebird-analysis/
```

To deploy:

1. Render Quarto or RMarkdown outputs to HTML into `/docs`.
2. Go to **Settings → Pages → Source → `main` branch → /docs folder**.
3. Save and publish.

---

## 📋 **.gitignore**

```
# R-related
.Rhistory
.Rproj.user
.RData
.Ruserdata
.Rproj

# Data files
*.rds
*.csv
*.zip
*.tar.gz

# System files
.DS_Store
```

---

## 📝 **Quarto Starter File (index.qmd)**

```markdown
---
title: "Frigatebird Movement and Oceanographic Drivers"
author: "Tanif Howlader"
date: "2025-06-01"
format:
  html:
    toc: true
    toc-depth: 2
    theme: cosmo
    code-fold: true
---

# **Abstract**

This study uses satellite-derived chlorophyll-a and bathymetric data to understand how frigatebird movement patterns are shaped by ocean productivity and underwater topography. By using GPS tracking data with environmental covariates, the study aims to uncover the ecological drivers influencing foraging and migration behaviour in these wide-ranging marine predators. I have combined high-resolution GPS tracks of frigatebirds with remotely sensed chlorophyll-a concentration (a proxy for ocean productivity) and bathymetric depth (representing seafloor features such as trenches and ridges). Environmental covariates were spatially matched to tracking points, allowing me to analyze bird-environment relationships. Analytical approaches included spatial density mapping, inhomogeneous Poisson point process modelling to test how bird density responds to environmental predictors, and bathymetric profiling across key ocean features. The analyses showed distinct areas of high frigatebird use, often overlapping with zones of elevated chlorophyll-a concentrations, suggesting that birds target productive waters likely associated with abundant prey. Spatial models confirmed significant correlations between bird density and both ocean productivity and bathymetric features. Notably, major underwater structures, such as deep ocean trenches and shallow ridges, emerged as influential spatial anchors shaping bird movement patterns. These findings improve our understanding of how apex marine predators interact with dynamic ocean environments. By linking seabird movement to underlying productivity gradients and topographic structures, we can better interpret habitat preferences and ecological requirements. This knowledge informs marine conservation by identifying critical foraging zones, which can help guide the design of marine protected areas and improve management strategies under changing ocean conditions. 



# **Introduction**

Frigatebirds (Fregata spp.) are large, wide-ranging seabirds that rely entirely on surface prey due to their inability to land on water. As apex predators in pelagic ecosystems, their ecology and migratory behaviour are strongly shaped by environmental features such as prey availability, ocean productivity, and physical habitat structure. Frigatebirds forage across vast oceanic expanses, tracking ephemeral prey resources such as flying fish and squid, which often aggregate in areas of elevated primary productivity and dynamic oceanographic features.

Among key environmental predictors, chlorophyll-a concentration serves as a proxy for phytoplankton biomass and overall ocean productivity, providing an indirect indicator of the food web base that supports frigatebird prey. Areas with high chlorophyll-a often coincide with enhanced foraging opportunities, as they attract zooplankton, small fish, and squid near the surface. Bathymetric features—such as trenches, ridges, and underwater slopes—also play a critical role by influencing local hydrodynamics, upwelling, and nutrient flux, which in turn affect prey aggregation patterns and seabird foraging efficiency.

Integrating animal tracking data with satellite-derived environmental datasets offers a powerful approach to understanding the spatial drivers of movement and habitat use in marine predators. By combining GPS-based frigatebird movement data with remotely sensed chlorophyll-a and bathymetric profiles, we can explore how these seabirds navigate complex oceanic landscapes, identify key foraging zones, and assess the environmental correlates that shape their distribution. Such integration is vital for addressing ecological questions about habitat selection, resource partitioning, and migratory connectivity, while also informing marine spatial planning and conservation efforts.

The main objective of this study is to quantify how frigatebird movement patterns relate to spatial variation in ocean productivity and seafloor topography. Specifically, I have aimed to:

Identify spatial hotspots of frigatebird use and assess their overlap with high-productivity zones marked by elevated chlorophyll-a concentrations.

Investigate the role of bathymetric features in shaping seabird density and distribution.

Model the strength and direction of relationships between environmental covariates and frigatebird density using spatial point process models.

Assess individual-level variability in environmental associations, evaluating whether some birds are more tightly linked to productivity gradients or bathymetric cues than others.

By addressing these objectives, this study aims to improve our understanding of the ecological mechanisms driving seabird movement across pelagic ecosystems and provide valuable insights for marine conservation management.

# **Data and Methods**

## **Data Sources**
The GPS tracking dataset consisted of high-resolution location data from 132,629 individual frigatebird positions, collected across multiple individuals (TagLocalIdentifiers) operating over the central Pacific Ocean (longitude ~–165° to –159°; latitude ~3° to 8° N). The data spanned multiple months, capturing both foraging and migratory movements across pelagic habitats. Each point included a timestamp, latitude, longitude, and associated metadata.

Environmental covariates were sourced from two key datasets:

Chlorophyll-a concentration: Daily remotely sensed satellite products accessed via the NOAA ERDDAP system using the R packages rerddap and rerddapXtracto. I have extracted data from the erdMBchlamday_LonPM180 dataset, providing gridded chlorophyll-a concentrations (mg/m³) as a proxy for ocean productivity.

Bathymetric data: Seafloor depth was obtained using the NOAA ETOPO 2022 15 Arc-Second Global Relief Model, downloaded and processed through the marmap R package. The extracted grid covered ~81 × 69 cells at 4 arc-minute (~7.4 km) resolution, spanning depths from –32 m (ridge/slope) to –5360 m (deep trench).

## **Data Processing**
I first cleaned the GPS tracking dataset by filtering out records with missing or invalid coordinates and ensuring that the timestamp formats were correct. The spatial coordinates were projected from geographic (WGS84) to UTM Zone 2N for accurate distance and area-based calculations. Temporal alignment was performed by rounding timestamps to the nearest month to match the monthly resolution of the chlorophyll-a dataset.

Environmental covariates were spatially matched to each GPS point using raster extraction methods (raster::extract), providing per-point chlorophyll-a and bathymetry values. To ensure strong modelling, I have filtered the dataset to retain only records with non-missing environmental covariates, removing ~40% of points that lacked chlorophyll-a coverage due to cloud contamination or sensor gaps.

## **Analytical Approach**
I have conducted multiple spatial analyses:

Density estimation: I have applied kernel density estimation (using the spatstat R package) to assess spatial hotspots of frigatebird use, both at the combined population level and for individual birds. Density surfaces were smoothed over a 10 km bandwidth, and all results were projected in km² units.

Inhomogeneous Poisson point process models (PPMs): To quantify the relationship between environmental covariates and frigatebird density, I have fitted PPMs with chlorophyll-a and bathymetry as predictors. Models were developed both at the combined and per-individual levels, allowing assessment of population-level drivers and individual variability.

Bathymetric profiling: I have constructed longitudinal depth profiles between key oceanographic features—specifically the deepest trench point (–164.7°, 3.34°) and the shallowest ridge (–159.37°, 3.88°)—using cross-section plots. Frigatebird crossing points along these transects were mapped and compared against seafloor topography to visualize how underwater features might shape movement.

Visualization: I have produced a series of high-resolution maps and figures, including faceted individual movement plots, hexbin chlorophyll maps, density maps, and annotated bathymetric cross-sections, for clear interpretation of results and communication of ecological patterns.

# **Results**

## **Bird Tracks over Chlorophyll-a and Bathymetry**
High-resolution maps showed frigatebird movements across the study area in the western Pacific Ocean (longitude –164.7° to –159.3°, latitude 3.2°–7.8° N), with tracks overlaid on chlorophyll-a concentrations and bathymetric features. Faceted maps by individual bird ID revealed diverse movement patterns, including long-distance crossings over deep ocean trenches (up to –5360 m) and more localized foraging over shallow ridges (–32 m). The combined plots highlighted that birds often traversed major underwater features, providing context for how physical oceanographic structures shape spatial use.

![image](https://github.com/user-attachments/assets/6dfb8097-cf31-4056-969c-83d86655ec48)
![image](https://github.com/user-attachments/assets/bb25aa25-2f90-41e2-9360-6ffb98bcd82a)
![image](https://github.com/user-attachments/assets/5537606c-5e72-45c1-9fb0-6ab08b585e9d)
![image](https://github.com/user-attachments/assets/e27ad376-fb9d-4aa5-8776-8852422a5072)

![image](https://github.com/user-attachments/assets/3dfd07ff-d3ab-4b13-bb5d-8dc2ee5d979d)
It is a hexabin map showing distribution of frigatebird foraging locations, colored by the average chlorophyll-a concentration at each location. Used 'log1p(chla)' to compress the range of chlorophyll values so extreme outliers do not dominate the color scaling. The plot shows where frigatebirds were tracked most frequently across the study region, how the average ocean productivity (via chlorophyll-a) varied spatially across their foraging range, and hotspots will appear as brightly colored hexagons where both bird density and productivity are high.

![image](https://github.com/user-attachments/assets/7d450304-02b5-41d6-b768-e1a3d97133df)
Bar chart of mean chla – Chl-a vs. Movement Density (Per Bird) - Are certain birds more specialized in productive areas?

![image](https://github.com/user-attachments/assets/422b054c-c259-4e3a-b175-e7bc278fc482)
Each subplot show chlorophyll-a at each location (colour of points) and allows comparison of how different birds use ocean productivity gradients. 

## **Density Hotspots**
Kernel density maps (10 km smoothing) identified clear spatial hotspots of frigatebird activity. These hotspots did not always align perfectly with highest Chla or shallowest depths. Overlaying density contours on environmental rasters showed that some hotspots occur in moderate-to-low Chla zones and over moderately deep offshore waters, not necessarily over shallow ridges or continental slopes. I have extracted the top 5% density pixels (hottest hotspots). These hotspot locations were combined with extracted Chla and depth values and saved for further analysis. 
![image](https://github.com/user-attachments/assets/7ba19617-d8b7-48c7-8ed4-f2e5883eaff9)
![image](https://github.com/user-attachments/assets/6cee23ed-5cc3-459d-92db-af0749568682)

Spatial Correlations Calculated Across the Entire Analysis Grid:

| Correlation Pair | Value  | Interpretation                                                                                                                             |
| ---------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Density \~ Chla  | –0.098 | Very weak negative correlation → bird density slightly lower in highest Chla zones (but effect is tiny, possibly due to offshore context). |
| Density \~ Depth | +0.317 | Moderate positive correlation → birds are more often found over deeper waters.                                                             |
| Chla \~ Depth    | –0.500 | Moderate negative correlation → deeper areas tend to have lower surface Chla, which matches expectations for offshore oligotrophic zones.  |


## **Individual Variability in Habitat Use**
Highlight differences between birds.

## **Point Process Model Results**
I have cleaned ~132,390 frigatebird tracking points, ensuring no duplicate locations and filtering out missing bathymetry values. For chlorophyll-a (Chl-a), I have imputed missing values with the median and applied a log-transform (log1p) to handle skewed distributions. I projected the data to UTM coordinates, which means all spatial measures (area, distance) are now in meters or kilometers, essential for ecological interpretation. I have converted the data into a point pattern object (ppp) and gridded the covariates (Chl-a and depth) into 10 km resolution rasters for the spatial models. I have fitted a nonstationary Poisson model:
![image](https://github.com/user-attachments/assets/d11b7690-65e3-40d7-b185-ef1714e145ba)
where:
λ(x,y) is the intensity (bird density) at spatial location (x,y).
Chl-a and Depth are your environmental covariates.

Key Results from the Model Output
| Coefficient | Estimate  | Interpretation                                                                                                                   |
| ----------- | --------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Intercept   | –13.75    | Baseline log-intensity when covariates = 0. Very low baseline density.                                                           |
| Chl-a (log) | +7.87     | **Strong positive effect** → Higher chlorophyll areas significantly increase frigatebird density.                                |
| Depth       | +0.000375 | **Small positive effect** → Increasing depth slightly increases density, possibly reflecting use near deeper trenches or slopes. |

All effects are highly significant (p < 0.001), confirmed by very large Z-values.

![image](https://github.com/user-attachments/assets/b22b5103-470e-4f55-a93d-cdf79c20a1d0)
![image](https://github.com/user-attachments/assets/ff879e08-0cfa-480f-b37d-3f064756c2d3)

## ** Bathymetric Profiles**

The bathymetric grid covers a tropical pelagic zone between –164.7° W and –159.3° W (81 × 69 cells, ~7.4 km resolution), with depths ranging from –5360 m (deep trench) to –32 m (shallow ridge). This range identifies both abyssal basins and slope features critical for understanding seabird-environment interactions.

![image](https://github.com/user-attachments/assets/2617f536-82f0-4279-b465-e5a6213351bd)

Contour maps, colored using terrain.colors(100), showed:

Green: deep basins (~–4200 to –5000 m)

Yellow/orange: mid-slope areas (~–2000 to –2200 m)

Brown: shallow shelves or ridges (~–1000 m or less)

These features provided the spatial framework for interpreting frigatebird movement.



Frigatebird Movements Overlaid on Bathymetry
![image](https://github.com/user-attachments/assets/2248dbc3-85e1-472b-bd45-4217998ccf8a)
The overlay of tracks and labeled trench/ridge points (with connecting lines) gave publication-ready figures clearly showing the birds’ spatial context relative to topographic features.
The tracks (plotted bird by bird) showed:

Frequent crossings over deep trenches (–164.7°, 3.34°)

Movements extending toward shallow ridges (–159.37°, 3.88°)

Some birds tightly clustered near slope zones; others ranged widely
![image](https://github.com/user-attachments/assets/b351160c-e5e8-43a9-98e4-1907405acc3a)
![image](https://github.com/user-attachments/assets/b2af87cf-3174-4db0-9610-1d859bc74e6c)
![image](https://github.com/user-attachments/assets/d5dd9b67-7059-428a-89e8-40e364410c76)
![image](https://github.com/user-attachments/assets/b2c3731c-3ff8-4195-9c98-e3b59c010aa8)
![image](https://github.com/user-attachments/assets/238b3043-d553-40ce-8494-75cd70157796)
![image](https://github.com/user-attachments/assets/1621a810-f8f0-448d-8cec-428ee079a439)
![image](https://github.com/user-attachments/assets/75723a69-7f81-4618-bc24-00e625af62af)

Bathymetric Cross-Section Profiles


A transect plotted between the deepest trench and shallowest ridge provided:
![image](https://github.com/user-attachments/assets/f80efcb3-b041-4efb-8557-f2c61c1777a4)

X-axis: horizontal distance (km)

Y-axis: depth (m, negative downward)

Blue line: bathymetric slope

Red dots: bird crossing points projected onto the transect

This visual cross-section helped communicate how birds interact with underlying slope gradients — e.g., whether they cross flat abyssal plains or target slope breaks where upwelling or prey concentrations are likely.

Slope Selection Analysis
By calculating slope (degrees) from the bathymetric data and comparing it at:

Bird-used points (presence)

Randomly drawn background points (pseudo-absence)

the logistic regression revealed:

Intercept (flat slope): significant baseline probability of use

Slope coefficient (per degree): +0.61 increase in log-odds of use (p < 0.0001)
→ This equates to ~84% higher odds of bird presence for each additional degree of slope

The chi-square test showed birds use slope categories (flat basin, moderate slope, steep slope) non-randomly:

Flat basins: underused (selection ratio ~0.73, avoidance)

Steep slopes: slightly overused (selection ratio ~1.06, neutral to mild preference)

This suggests that frigatebirds selectively concentrate over slope features, likely because:

Slopes drive upwelling, enriching surface waters with nutrients

Slopes aggregate prey (fish, squid) near slope breaks or escarpments

Flat basins may offer less predictable or dispersed prey resources
![image](https://github.com/user-attachments/assets/cc1c747d-7b7a-4f12-9a69-5f3fbfcc47e5)


# **Discussion**

Despite a strong positive coefficient for chlorophyll-a in the point process model, the spatial correlation between bird density and Chla across the study area was weak. This suggests that frigatebirds do not necessarily concentrate in the absolute highest-productivity zones but may target moderately productive patches that offer favorable foraging conditions. Depth showed a stronger spatial correlation, with birds concentrating over deeper pelagic habitats, likely due to the presence of oceanographic features such as slopes, ridges, or upwelling zones that enhance prey availability. As expected, depth and Chla were negatively correlated, reflecting lower surface productivity over deep ocean basins. Overall, the statistical models confirm that frigatebird density is significantly associated with both surface productivity (Chla) and bathymetric depth, highlighting the combined importance of biological and physical habitat drivers. While the model is limited by missing background environmental data (~30% of points), it strongly demonstrates that frigatebirds use slope-rich, moderately productive areas rather than flat or extreme environments, supporting ecological hypotheses about pelagic predator space use.




```

---














