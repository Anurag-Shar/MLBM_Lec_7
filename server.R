library(shiny)
library(quantmod)
library(ggplot2)
library(dplyr)
library(tidyr)

server <- function(input, output, session) {
  observeEvent(input$fetch, {
    stock_symbol <- input$stock
    date_range <- input$dates
    
    # Fetch stock data
    stock_data <- tryCatch({
      getSymbols(stock_symbol, src = "yahoo", from = date_range[1], to = date_range[2], auto.assign = FALSE)
    }, error = function(e) {
      NULL
    })
    
    # Fetch Nifty 50 index data
    nifty_data <- tryCatch({
      getSymbols("^NSEI", src = "yahoo", from = date_range[1], to = date_range[2], auto.assign = FALSE)
    }, error = function(e) {
      NULL
    })
    
    if (is.null(stock_data) || is.null(nifty_data)) {
      return()
    }
    
    # Convert to data frame
    stock_df <- data.frame(Date = index(stock_data), Price = Cl(stock_data))
    nifty_df <- data.frame(Date = index(nifty_data), Price = Cl(nifty_data))
    
    # Stock Price Plot
    output$stockPlot <- renderPlot({
      ggplot() +
        geom_line(data = stock_df, aes(x = Date, y = Price, color = "Stock Price"), size = 1) +
        geom_line(data = nifty_df, aes(x = Date, y = Price, color = "Nifty 50 Index"), size = 1) +
        labs(title = "Stock Price vs Nifty 50", x = "Date", y = "Price", color = "Legend") +
        theme_minimal()
    })
    
    # Percentage Change Calculation
    stock_df <- stock_df %>%
      mutate(Change = (Price / first(Price) - 1) * 100)
    
    nifty_df <- nifty_df %>%
      mutate(Change = (Price / first(Price) - 1) * 100)
    
    percent_df <- merge(stock_df[, c("Date", "Change")], nifty_df[, c("Date", "Change")], by = "Date", suffixes = c("_Stock", "_Nifty"))
    
    # Percentage Change Plot
    output$percentChangePlot <- renderPlot({
      ggplot(percent_df, aes(x = Date)) +
        geom_line(aes(y = Change_Stock, color = "Stock"), size = 1) +
        geom_line(aes(y = Change_Nifty, color = "Nifty 50"), size = 1) +
        labs(title = "Percentage Change vs Nifty 50", x = "Date", y = "Percentage Change", color = "Legend") +
        theme_minimal()
    })
  })
}
