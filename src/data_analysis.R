library(ggplot2) 
library(tidyr)
library(plyr)
library(lubridate)
library(scales)
library(reshape2)
library(summarytools) #dataframe summaries
library(ggfortify) #autoplot
library(sjPlot) #tabmodel

#### Beginning data extraction and cleaning process ####

source("./src/fn_data_preperation.R")
fn.analysis("GE", "Stock.Price","bsi_score")



fn.data_diagnostics()






