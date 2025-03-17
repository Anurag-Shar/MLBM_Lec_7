library(shiny)

ui <- fluidPage(
  titlePanel("Nifty 50 Stock Tracker"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("stock", "Select a Nifty 50 Company:", 
                  choices = c("RELIANCE.NS" = "Reliance Industries",
                              "TCS.NS" = "Tata Consultancy Services",
                              "INFY.NS" = "Infosys",
                              "HDFCBANK.NS" = "HDFC Bank",
                              "ICICIBANK.NS" = "ICICI Bank"),
                  selected = "RELIANCE.NS"),
      
      dateRangeInput("dates", "Select Date Range:", 
                     start = Sys.Date() - 30, end = Sys.Date()),
      
      actionButton("fetch", "Fetch Data")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Stock Price", plotOutput("stockPlot")),
        tabPanel("Percentage Change", plotOutput("percentChangePlot"))
      )
    )
  )
)
