library(testthat)
library(ggplot2) 
library(tidyr)
library(plyr)
library(lubridate)
library(scales)
library(reshape2)
library(summarytools) #dataframe summaries
library(ggfortify) #autoplot
library(sjPlot) #tabmodel
library(ggpubr) # wrapper for ggplot

source("./src/fn_data_preperation.R")
test_that("Files/Folder Validation", {expect_equal(fn.analysis("H"),TRUE)})


fn.analysis("F")
cfn.data_diagnostics()






