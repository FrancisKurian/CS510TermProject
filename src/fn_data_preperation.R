fn.analysis <- function(company){
  
CompanyNames <- './data/CompanyNames.csv'

# error trap and validation added - Peer review
  
  if (class(try(read.csv(CompanyNames, header = T),silent=T)) == "try-error") {
    print(message("Please change your Knit/Knit directory to 'Project Directory or Current Working Directory'. This error normally appears when 
        R Markdown knit/Knit Direcotry is set to 'Document directory'"))
   break  } 
  else {
    df_companies <- read.csv(CompanyNames, header = T)
  }
  

  
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
  

 
 
 fn.regress <- function(company){
   
   #create local dataframes based on the company names
   
   if (!exists(paste0("df_",company))) {
     print("Company Datafiles Missing.Process Terminated")
     return(FALSE)
   }else {
     
     df_b  <- get(paste0("df_",company,"_BSI"))
     df_s  <- get(paste0("df_",company))
     df_cname <- df_companies[df_companies[,1]  == company, ]
   }
   
   
   # check all three datasets for data issues and make it global
   
   d1 <- dfSummary(df_forex, style = "grid", plain.ascii = TRUE)
   # view(dfSummary(df_forex, style = "grid", plain.ascii = TRUE))
   d2 <- dfSummary(df_s, style = "grid", plain.ascii = TRUE)
   d3 <- dfSummary(df_b, style = "grid", plain.ascii = TRUE)
   
   df_forex <- na.omit(df_forex)
   d4 <- dfSummary(df_forex, style = "grid", plain.ascii = TRUE)
   
   # cat(df_cname[1,2])
   # print(d1)
   # print(d2)
   # print(d4)
   
   # merge all three datasets
   
   df_all <- merge(df_b, df_forex, by="period",all.x=TRUE )  # merge with Forex file
   
   df_all <- merge(x=df_all, y=df_s, by="period",all.x=TRUE )  # merge with stock price 
   
   df_all <- subset(na.omit(df_all),select=c(period,	ticker.x,	name.x,	bsi_score,	
                                             USDxINR,	USDxEUR,	USDxYEN,	Close,	Volume))
   
   # dfSummary(df_all, style = "grid", plain.ascii = TRUE)
   
   df_all <- rename(df_all, c("ticker.x"="ticker", "name.x"="CompanyName",
                              "Close"="Stock.Price", "Volume"="Stock.Volume"))
   
   d5 <- dfSummary(df_all, style = "grid", plain.ascii = TRUE) #output saved global
   
   # Scatterplot the variable relationship to visualize.Output saved global
   
   # scatter <- ggplot(df_all, aes(x=df_all[,var.X], y=df_all[,var.Y])) + 
   #   geom_point()+
   #   geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_cname[1,2] ) +
   #   xlab(var.X) + ylab(var.Y)
   
    scatter1 <- ggplot(df_all, aes(x=bsi_score, y=Stock.Price)) + 
     geom_point()+
     theme(plot.title = element_text(size = 8))+
     geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_all[1,3] ) 
   
   scatter2 <- ggplot(df_all, aes(x=USDxEUR, y=Stock.Price)) + 
     geom_point()+
     theme(plot.title = element_text(size = 8))+
     geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_all[1,3] ) 
   
   scatter3 <- ggplot(df_all, aes(x=USDxYEN, y=Stock.Price)) + 
     geom_point()+
     theme(plot.title = element_text(size = 8))+
     geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_all[1,3] ) 
   
   
   scatter4 <- ggplot(df_all, aes(x=USDxINR, y=Stock.Price)) + 
     geom_point()+
     theme(plot.title = element_text(size = 8))+
     geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_all[1,3] ) 
   
   
   scatter <-  ggarrange(scatter1, scatter2, scatter3, scatter4 + rremove("x.text"), 
             labels = c("A", "B", "C","D"),
             ncol = 2, nrow = 2)
   
   
   # Fit the simple regression model and create a summary
   
   
   multi.fit <- lm(Stock.Price~bsi_score+USDxEUR+USDxYEN+USDxINR, data=df_all)
   std_results <- summary(multi.fit) # std model results
   tab_results <- tab_model(multi.fit) # tabulated results
   residual_plot <- autoplot(multi.fit) # residuals plot
   
   print(scatter)
   
   
   
   cat("MULTIPLE REGRESSION ANALYSIS RESULTS")
   print(std_results)
   print(residual_plot)
   
   return(TRUE)
 }
 
 fn.regress(company)
  
}



fn.data_diagnostics <- function(){
  
  CompanyNames <- './data/CompanyNames.csv'
  
  # error trap and validation added - Peer review
  
  if (class(try(read.csv(CompanyNames, header = T),silent=T)) == "try-error") {
    print(message("Please change your Knit/Knit directory to 'Project Directory or Current Working Directory'. This error normally appears when 
        R Markdown knit/Knit Direcotry is set to 'Document directory'"))
    break  } 
  else {
    df_companies <- read.csv(CompanyNames, header = T)
  }
  
  # print(head(df_companies))
  
  
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
  
  # sapply(df_forex, class)
  # head(df_forex)
  # summary(df_forex)
  
  
  
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
  
 # print( summary(df_c_all) )# Stock price series
 # print( summary(df_bsi_all)) #BSI index series
  
  print( ggplot(data = df_c_all, aes(period, Close)) +
           geom_line(color = "steelblue", size = 1) +
           geom_point(color = "steelblue") + 
           labs(title = "Time Series of Stock Prices by Company",
                subtitle = "(Visualization to check any obvious data issues)",
                y = "Stock Prices - Closing ", x = " Date") + 
           theme(
             plot.title = element_text(hjust = 0, size = 10),    # Center title position and size
             plot.subtitle = element_text(hjust = 0,size = 8),            # Center subtitle
             plot.caption = element_text(hjust = 0, face = "italic")# move caption to the left
           )+
           facet_wrap(~name,scales="free",ncol=2))
  
  print(ggplot(data = df_c_all, aes(period, Volume)) +
          geom_line(color = "steelblue", size = 1) +
          geom_point(color = "steelblue") + 
          labs(title = "Time Series of Stock trading volume",
               subtitle = "(Visualization to check any obvious data issues)",
               y = "Daily Trading Volume", x = " Date") + 
          theme(
            plot.title = element_text(hjust = 0, size = 10),    # Center title position and size
            plot.subtitle = element_text(hjust = 0,size = 8),            # Center subtitle
            plot.caption = element_text(hjust = 0, face = "italic")# move caption to the left
          )+
          facet_wrap(~name,scales="free",ncol=2) +
          scale_y_continuous(labels = label_number(suffix = " M", scale = 1e-6)))
  
  print(ggplot(data = na.omit(df_bsi_all), aes(period,bsi_score)) +
          geom_line(color = "steelblue", size = 1) +
          geom_point(color = "steelblue") + 
          labs(title = "Time Series of Business Sentiments Index",
               subtitle = "(Visualization to check any obvious data issues)",
               y = "Business Sentiment Index", x = " Date") + 
          theme(
            plot.title = element_text(hjust = 0, size = 10),    # Center title position and size
            plot.subtitle = element_text(hjust = 0,size = 8),            # Center subtitle
            plot.caption = element_text(hjust = 0, face = "italic")# move caption to the left
          )+
          facet_wrap(~name,scales="free",ncol=3) )
  
  print( ggplot(na.omit(df_forex2), aes(period,value)) + 
           geom_point() + 
           stat_smooth(formula = y ~ x,method=loess) +
           theme(
             plot.title = element_text(hjust = 0, size = 10),    # Center title position and size
             plot.subtitle = element_text(hjust = 0,size = 8),            # Center subtitle
             plot.caption = element_text(hjust = 0, face = "italic")# move caption to the left
           )+
           facet_wrap(~variable,scales="free",ncol=1)+ 
           labs(title = "Time Series of Exchange Rates",
                subtitle = "(Visualization to check any obvious data issues)",
                y = "Exchange Rates:$ vs YEN, EURO,Rupee", x = " Date"))
}







