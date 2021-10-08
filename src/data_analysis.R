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

CompanyNames <- './data/CompanyNames.csv'
df_companies <- read.csv(CompanyNames, header = T)
head(df_companies)

ForexFile <- './data/FederalReserve_CurrencyXchangeRate.csv'
headers <- read.csv(ForexFile, skip = 5 , header = F, nrows = 1) #header info is at row #6
df_forex <- read.csv(ForexFile, skip = 6, header = F) #data begins at row #7 
colnames(df_forex) <- headers #apply headers 
df_forex$period <- as.Date(df_forex$`Time Period`) #format as date

df_forex$USDxINR <- as.numeric(gsub("ND","",df_forex$RXI_N.B.IN)) ##clean & format as number
df_forex$USDxEUR <- as.numeric(gsub("ND","",df_forex$`RXI$US_N.B.EU`))
df_forex$USDxYEN <- as.numeric(gsub("ND","",df_forex$RXI_N.B.JA))

df_forex <- subset(df_forex,select = c(period, USDxINR, USDxEUR, USDxYEN))
df_forex <- df_forex[!duplicated(df_forex$period),] # remove duplicates
df_forex2 <- melt(df_forex, id.vars="period") # for all in one graphs

sapply(df_forex, class)
head(df_forex)
summary(df_forex)



for (i in df_companies$ticker) {
  
  if (!file.exists(paste0("./data/",i, ".csv"))) {
    print("Please remove the Company. Files Missing for:")
    print(i)
    break
  }
  
  #process stock price/volume files from data directory
  #pick the csv file of every company in the input list and create a dataframe in a loop
  
  df_c <- read.csv(paste0("./data/",i, ".csv"), header = T) 
  df_c$period <- as.Date(df_c$Date) # add a date field 
  df_c$ticker <- i # attach ticker
  df_companies_subset <- subset(df_companies, ticker==i) 
  df_c <- merge(x=df_c, y=df_companies_subset, by="ticker",all.x=TRUE )#to get name
  assign(paste0("df_",i), df_c) #create a new data frame for later use
  
  # Appends company data frames to one for graphs.   
  
  if (exists("df_c_all")) {
    df_c_all <- rbind(df_c_all, df_c)
    
  }else {
    df_c_all=df_c}
  
  # Process Sentiments Index from data directory
  
  df_bsi <- read.csv(paste0("./data/",i, "_BSI.csv"), header = T) 
  df_bsi$period <- as.Date(parse_date_time(df_bsi$created_date, c('%Y-%m-%d', '%m/%d/%y')))
  df_bsi$ticker <- i # attach ticker
  df_bsi <- merge(x=df_bsi, y=df_companies_subset, by="ticker",all.x=TRUE )##to get name
  df_bsi <- df_bsi[c('ticker','period','name','bsi_score')]
  
  assign(paste0("df_",i,"_BSI"), df_bsi) #create a new data frame forlater use
  
  # create a data frame to append  every data frame for graphs 
  
  if (exists("df_bsi_all")) {
    df_bsi_all <- rbind(df_bsi_all, df_bsi)
    
  }else {
    df_bsi_all <- df_bsi}

}

#### End of data extraction and cleaning process ####

summary(df_c_all) # Stock price series
summary(df_bsi_all) #BSI index series

ggplot(data = df_c_all, aes(period, Close)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue") + 
  labs(title = "Time Series of Stock Prices by Company",
       subtitle = "(Visualization to check any obvious data issues)",
       y = "Stock Prices - Closing ", x = " Date") + 
  facet_wrap(~name,scales="free",ncol=2)

ggplot(data = df_c_all, aes(period, Volume)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue") + 
  labs(title = "Time Series of Stock trading volume",
       subtitle = "(Visualization to check any obvious data issues)",
       y = "Daily Trading Volume", x = " Date") + 
  facet_wrap(~name,scales="free",ncol=2) +
  scale_y_continuous(labels = label_number(suffix = " M", scale = 1e-6))

ggplot(data = na.omit(df_bsi_all), aes(period,bsi_score)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue") + 
  labs(title = "Time Series of Business Sentiments Index",
       subtitle = "(Visualization to check any obvious data issues)",
       y = "Business Sentiment Index", x = " Date") + 
  facet_wrap(~name,scales="free",ncol=3) 

ggplot(na.omit(df_forex2), aes(period,value)) + 
  geom_point() + 
  stat_smooth(formula = y ~ x,method=loess) +
  facet_wrap(~variable,scales="free",ncol=1)+ 
  labs(title = "Time Series of Exchange Rates",
       subtitle = "(Visualization to check any obvious data issues)",
       y = "Exchange Rates:$ vs YEN, EURO,Rupee", x = " Date")


#### Beginning of the generic function Calls ####

source("./src/fn_regression.R")
fn.regress("GE", "Stock.Price","USDxEUR")

# Printing the function outputs made available as global(optional). 
print(d1)
print(d2)
print(d3)
print(d4)
print(d5)
print(scatter)
print(std_results)
print(tab_results)
print(residual_plot)




