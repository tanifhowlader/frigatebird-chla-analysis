# **Frigatebird Movement and Environmental Covariates Analysis**

This repository contains the full **analysis workflow** for linking frigatebird GPS tracking data with remotely sensed environmental variables, including **chlorophyll-a concentration** and **bathymetric depth**. The project uses R and open-source spatial packages to understand how marine top predators interact with oceanographic features across the central Pacific Ocean.

---

## 📂 **Repository Structure**

```
frigatebird-analysis/
├── data/
│   ├── frigatebird_tracks_cleaned.rds
│   ├── bathymetry_data.rds
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

We combine **point process models**, **kernel density estimation**, and **spatial visualizations** to explore habitat use patterns, identify migration corridors, and assess individual variability.

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
$ git clone https://github.com/yourusername/frigatebird-analysis.git

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
https://yourusername.github.io/frigatebird-analysis/
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
author: "Your Name"
date: "2025-06-01"
format:
  html:
    toc: true
    toc-depth: 2
    theme: cosmo
    code-fold: true
---

# **Abstract**

This report summarizes analyses linking frigatebird tracking data with oceanographic covariates, focusing on spatial patterns, density, and environmental associations.

# **Introduction**

_Provide background on why this analysis matters._

# **Data and Methods**

## **Tracking Data**
Describe data source, number of points, time range, preprocessing.

## **Environmental Covariates**
List chlorophyll-a extraction, bathymetry download, spatial matching.

## **Analysis Methods**
Point process models, density estimation, cross-section profiles.

# **Results**

## **Density Maps**
Insert maps, describe patterns.

## **Environmental Models**
Summarize model outputs, coefficients, significance.

## **Individual Variability**
Highlight differences between birds.

# **Discussion**

Discuss ecological interpretations, limitations, and next steps.

# **References**

_Add citations and data sources._
```

---

✅ Let me know if you want me to generate these as ready-to-use files and bundle them into a push-ready GitHub package!












