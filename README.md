# Understanding Stock Price Beahavior using an R Based Analytical Framework
Mid-Term Project-Francis Kurian

## About the project
Stock market behavior is a well researched area with plenty of historic information available free. Several studies link the stock price movement of a company to the perception of the market participant about that company.IBM Watson APIs enable tracking of company specific news and social media interactions through extensive text mining and help come out with a Sentiment (Negative and positive emotions expressed through words or text) Index for a business.Business Sentiment Index(BSI) is one such index calculated by TRaiCE Fintech at company level. In addition, to understand  sensitivity of stock prices to Global events, Foreign Exchanges Rate is also introduced as an additional measure.  Idea here is to demonstrate how to extract various relevant data elements from diverse sources, transform and load them into an analytic framework to visualize and understand the inherent relationships.

## Objective of the project

Primary objective is to develop an analysis system using various R libraries. Extracting and processing data from multiple sources, data cleaning, simplifying repetitive tasks using control structures and functions, use of data visualization techniques and application of statistical methods  are the focus areas while building the framework in R. In other words, learn to write reproducible R code while analyzing stock price movement with respect to Business Sentiment Index(BSI) and Foreign Exchange Rates is the objective of this project.

## To run the analysis

1. Download latest version of code and data from github and extract to a local folder.
2. Before execute any code, please take a look at the Expected output of RMD saved in this location as PDF: "./MidTermProject_RMarkdown.pdf" 
3. Open RMD File in R Studio: "./MidTermProject_RMarkdown.Rmd"
4. Please change your Knit/Knit directory to  'Current Working Directory'.  
5. 'Knit to PDF' to see the output.  Optionally, you can run the R code chunks 

## To repeat the analysis for various companies
Modify the arguments(company)to function, fn.analysis() -Line # 47 in R Markdown
Data for 6 companies below are available. 
GE,BA,F,FE,KHC,OXY

For any reproducible error, please message me in slack.

##  Final Paper
Final paper location "./final_paper_francis.pdf". Final paper RMD file location "./final_paper_francis.rmd" . The documents files are now moved into the root folder intentionally to run without any directory changes.
