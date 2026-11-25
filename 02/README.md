# Arbor Lab 02: Testing for forest carbon differences from allometric equations

This session covered quantitative methods for comparing two tree carbon predictions made on the same stands. Using Jenkins and NSVB (National-Scale Volume and Biomass) estimates for spruce-fir stands in New York, we asked: do the equations differ, are they close enough to be interchangeable, and how uncertain is the gap?

- **Paired t-test:** tests whether the mean within-stand difference between two methods is zero. 
- **Equivalence test (TOST):** reverses the hypotheses to test whether the difference lies within a pre-set margin.
- **Bootstrap confidence interval:** resamples stands with replacement and recomputes the mean difference each time. 

## Data
We used tree-level observations from New York State (see [FIA data](https://apps.fs.usda.gov/fia/datamart/datamart.html)) and compared the resulting carbon estimates.

## Running the demo
1. Open `arbor_lab_02.qmd` in RStudio or Positron.
2. Install the packages: `install.packages(c("tidyverse", "broom", "TOSTER", "boot"))`.
3. Render the document.

![Slide thumbnail for Arbor Lab 02](arbor_lab_02_thumbnail.jpg)
