### Download the packages if they do not exist in the environment
library(RSelenium) 
## Tutorial to install RSelenium, goto https://callumgwtaylor.github.io/blog/2018/02/01/using-rselenium-and-docker-to-webscrape-in-r-using-the-who-snake-database/
library(gtools)
library(rvest)
library(dplyr)

## Initialisng headless browser
driver<- rsDriver(browser=c("chrome"))
remDr <- driver[["client"]]
remDr$navigate("https://aps.dac.gov.in/LUS/Public/Reports.aspx") 

## Getting the list of states
dropdown.state <- remDr$findElement(using = 'id', "DdlState")
state <- as.vector(unlist(strsplit(as.character(dropdown.state$getElementText()),split = "\n ")))
state <- state[-1] 


## Downloading all the required files
for(i in 1:length(state)){
  dropdown.state <- remDr$findElement(using = 'id', "DdlState")
  dropdown.state$sendKeysToElement(list(state[i]))
  
  select.year <- remDr$findElement(using = 'id', "DdlYear")
  year <- as.vector(unlist(strsplit(as.character(select.year$getElementText()),split = "\n")))
  
  for (j in 1:length(year)) {
    select.year <- remDr$findElement(using = 'id', "DdlYear")
    select.year$sendKeysToElement(list(year[j]))
    
    select.format <- remDr$findElement(using = 'id', "DdlFormat")
    select.format$sendKeysToElement(list("Excel"))
    
    proceed <- remDr$findElement(using = 'id', "TreeView1t2")
    proceed$clickElement() 
    
    try(remDr$dismissAlert())
  }
}

## Code to assimilate all the downloaded files
