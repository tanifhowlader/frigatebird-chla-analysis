# Loading Required Packages

library(ggplot2)
library(dplyr)
library(viridis)
library(rerddap)
library(rerddapXtracto)
library(raster)
library(lubridate)
library(sp)

# Loading Cleaned Frigatebird Track Data

frigatebird.tracks <- readRDS("C:/Users/Tanif/Downloads/Frigatebird_evars/frigatebird_tracks_cleaned.rds")

# Inspect structure
str(frigatebird.tracks)
summary(frigatebird.tracks)
head(frigatebird.tracks)

# Define Spatial and Temporal Extents

extent_to_download <- data.frame(
  Longitude = range(frigatebird.tracks$LocationLong, na.rm = TRUE),
  Latitude = range(frigatebird.tracks$LocationLat, na.rm = TRUE)
)

dates_to_download <- data.frame(
  min_date = min(frigatebird.tracks$Timestamp, na.rm = TRUE),
  max_date = max(frigatebird.tracks$Timestamp, na.rm = TRUE)
)

# Setting Output Directory and Cache

out_folder <- "C:/Users/Tanif/Downloads/Frigatebird_evars/"
dir.create(out_folder, showWarnings = FALSE)
rerddap::cache_setup(full_path = out_folder, temp_dir = FALSE)

# Downloading Chlorophyll-a (MODIS Aqua, Daily)

CHL <- rerddap::info("erdMBchlamday_LonPM180")

chl <- rxtracto_3D(
  dataInfo = CHL,
  parameter = "chlorophyll",
  xcoord = extent_to_download$Longitude,
  ycoord = extent_to_download$Latitude,
  tcoord = c(dates_to_download$min_date, dates_to_download$max_date),
  zcoord = c(0),
  verbose = TRUE,
  cache_remove = FALSE
)

chl_tidy <- tidy_grid(chl)
chl_tidy$MonthDate <- floor_date(as.POSIXct(chl_tidy$time), "month")


# Loading Chlorophyll Raster (NetCDF File)

chl_file <- "C:/Users/Tanif/Downloads/Frigatebird_evars/chlorophyll_download.nc"
chl_stack <- stack(chl_file, varname = "chlorophyll")
print(chl_stack)
nlayers(chl_stack)
names(chl_stack)[1:5]

# Building Date Lookup Table

DateTable <- data.frame(xdate = names(chl_stack)) %>%
  mutate(
    CleanName = gsub("^X", "", xdate),  # Remove leading 'X'
    CleanName = gsub("\\.", "-", substr(CleanName, 1, 10)),  # Format as YYYY-MM-DD
    TimePart = gsub(".*?(\\d{2}\\.\\d{2}\\.\\d{2})$", "\\1", xdate),  # Optional, not used
    DateTime = ymd(CleanName),
    MonthDate = floor_date(DateTime, unit = "month")
  )

glimpse(DateTable)


# Extracting Chlorophyll-a for each Track Point

frigatebird.tracks$MonthDate <- floor_date(frigatebird.tracks$Timestamp, "month")
frigatebird.tracks$chla <- NA_real_

for (m in unique(frigatebird.tracks$MonthDate)) {
  message("Processing month: ", m)
  
  datex <- DateTable$xdate[DateTable$MonthDate == m]
  if (length(datex) == 0 || any(is.na(datex))) next
  datex <- datex[1]  # Use first match only
  
  track_subset <- which(frigatebird.tracks$MonthDate == m)
  
  pts <- data.frame(
    Longitude = frigatebird.tracks$LocationLong[track_subset],
    Latitude = frigatebird.tracks$LocationLat[track_subset]
  )
  coordinates(pts) <- ~Longitude + Latitude
  crs(pts) <- CRS("+proj=longlat +datum=WGS84")
  
  frigatebird.tracks$chla[track_subset] <- extract(chl_stack[[datex]], pts)
}


# Saving Output

saveRDS(frigatebird.tracks, file = "C:/Users/Tanif/Downloads/Frigatebird_evars/frigatebird_tracks_with_chla.rds")


# Visualizing All Tracks by Bird ID

ggplot(frigatebird.tracks, aes(x = LocationLong, y = LocationLat, color = TagLocalIdentifier)) +
  geom_path(alpha = 0.5, linewidth = 0.3) +
  coord_fixed() +
  scale_color_viridis_d(option = "turbo") +
  theme_minimal() +
  labs(
    title = "Frigatebird Tracks (June 2022 – March 2023)",
    x = "Longitude",
    y = "Latitude",
    color = "Bird ID"
  )

# Visualizing Chlorophyll-a Along a Specific Track

ggplot(data = frigatebird.tracks %>% filter(TagLocalIdentifier == "eobs_9830")) +
  geom_path(aes(x = LocationLong, y = LocationLat), linewidth = 0.4) +
  geom_point(aes(x = LocationLong, y = LocationLat, fill = log(chla)), shape = 21, size = 3) +
  scale_fill_viridis_c(option = "plasma", name = "log(Chl-a)") +
  labs(title = "Frigatebird Movement Colored by Chlorophyll-a") +
  theme_minimal()
