# Understanding Stock Price Beahavior using an R Based Analytical Framework
Mid-Term Project-Francis Kurian

## About the project
Stock market behavior is a well researched area with plenty of historic information available free. Several studies link the stock price movement of a company to the perception of the market participant about that company.IBM Watson APIs enable tracking of company specific news and social media interactions through extensive text mining and help come out with a Sentiment (Negative and positive emotions expressed through words or text) Index for a business.Business Sentiment Index(BSI) is one such index calculated by TRaiCE Fintech at company level. In addition, to understand  sensitivity of stock prices to Global events, Foreign Exchanges Rate is also introduced as an additional measure.  Idea here is to demonstrate how to extract various relevant data elements from diverse sources, transform and load them into an analytic framework to visualize and understand the inherent relationships.

## Objective of the project

Primary objective is to develop an analysis system using various R libraries. Extracting and processing data from multiple sources, data cleaning, simplifying repetitive tasks using control structures and functions, use of data visualization techniques and application of statistical methods  are the focus areas while building the framework in R. In other words, learn to write reproducible R code while analyzing stock price movement with respect to Business Sentiment Index(BSI) and Foreign Exchange Rate is the objective of this project.

## To run the analysis
1. Download "CS510TermProject-1.0"" from github and extract to a local folder.
2. Rstudio: File/Open File: "./docs/MidTermProject_RMarkdown.Rmd" ( OR Run R file : "./src/data_analysis.R" . Rmd file is strongly recommended as displays all outputs in one place)
3. Please install all the libraries listed in the beginning of the code.  
4. Expected output of Rmd file is saved in this location as PDF: "./docs/MidTermProject_RMarkdown.pdf"

## To repeat the analysis for various companies
Modify the arguments(company)to function, fn.regress(company,var.Y,var.X)
Data for 6 companies below are available. 
GE,BA,F,FE,KHC,OXY

For example, fn.regress("F", "Stock.Price","bsi_score") will conduct the analysis for Ford. 
