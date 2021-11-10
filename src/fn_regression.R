fn.regress <- function(company,var.Y,var.X){
  
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
  
  scatter <- ggplot(df_all, aes(x=df_all[,var.X], y=df_all[,var.Y])) + 
    geom_point()+
    geom_smooth(formula = y ~ x,method=lm)+ ggtitle(df_cname[1,2] ) +
    xlab(var.X) + ylab(var.Y)
  
  print(scatter)
  
  # Fit the simple regression model and create a summary
  
  multi.fit <- lm(Stock.Price~USDxEUR, data=df_all)
  std_results <- summary(multi.fit) # std model results
  tab_results <- tab_model(multi.fit) # tabulated results
  residual_plot <- autoplot(multi.fit) # residuals plot
  
  print(std_results)
  print(residual_plot)
  
  return(TRUE)
}