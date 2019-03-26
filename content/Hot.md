---
title: Kent Crime Hotspot App
date: "2016-05-05T21:48:51-07:00"
layout: about_page
---

### Summary

The Kent Crime Hotspot App is a proof of concept, calling publically available data from the Police UK and subjecting it to an automatic raster heat map algorithm that displays potential crime density. 

### Method

To begin data is called form the police data API, specifying an arbitrary area of North Kent (including parts of Greater London). This data is subject to an anonymization algorithm that disguises the true location of the crime committed.  

The raster is created by using the R ‘KernelSmooth’ package. It returns a set of Cartesian coordinates for each point to produce a matrix for density. The kernel method used for this analysis was bivariate normal density.

Due to a delay in data supplied by the API for investigation, safety and administrative reasons, there is a 90-day delay applied to the data to ensure any call to the API will yield a data set.

### Interaction

The two parameters the user can specify are the categories of crime committed and the bandwidth smoothing used in creating a kernel density estimate used for the raster map.


<iframe scrolling="no" frameborder="no" height=1000px width=1000px src="https://jkbapps.shinyapps.io/apps/"> </iframe>