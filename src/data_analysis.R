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
#test the data files exists for the company to be analyzed and functions returns expected results
#When test fails, relevant messages will be printed to show the issue.

test_that("Files/Folder Validation", {expect_equal(fn.analysis("F"),TRUE)})

fn.analysis("F")
cfn.data_diagnostics()






