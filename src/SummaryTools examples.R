library(summarytools)
st_options(plain.ascii = FALSE,style= "rmarkdown")


# freq()
freq(iris$Species)

# Cross-Tabulations: ctable()

ctable(x = tobacco$smoker, 
       y = tobacco$diseased, 
       prop = "r")   # Show row proportions c-column, t= total, n=none


# Descriptive Statistics: descr()
descr(iris)

# descr() : Transposing and selecting statistics
descr(iris,
      stats     = c("mean", "sd"),
      transpose = TRUE,
      headings  = FALSE)

# Data Frame Summaries: dfSummary()
dfSummary(tobacco, 
          plain.ascii  = FALSE, 
          style        = "grid", 
          graph.magnif = 0.75, 
          valid.col    = FALSE,
          tmp.img.dir  = "/tmp")