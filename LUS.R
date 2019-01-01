library(RSelenium) 
library(gtools)
library(rvest)
library(dplyr)
driver<- rsDriver(browser=c("chrome"))
remDr <- driver[["client"]]
remDr$navigate("https://aps.dac.gov.in/LUS/Public/Reports.aspx") 


dropdown.state <- remDr$findElement(using = 'id', "DdlState")
state <- as.vector(unlist(strsplit(as.character(dropdown.state$getElementText()),split = "\n ")))
state <- state[-1] 



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