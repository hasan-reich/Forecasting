# I will be attempting to forecast the s&p500 for the year 2016 using previous data

#packages that will be used

install.packages('quantmod')
library(quantmod)
install.packages('forecast')
library(forecast)

#importing s&p data from yahoo finance

getSymbols("^GSPC", src ="yahoo")
sp500 = GSPC

# take a look at coulmns of the data
head(sp500)

# subset data to include previous six years
sp500 = sp500["2009-01-01/2015-01-01"]

# subsetting for the points at closing only, fourth column in the data
sp500 = sp500[,4]

# plot the data to take a look at it
plot(sp500)

# there appears to be trend and seaosnality in our data
# to get rid of this we do so by differencing

sp500 = diff(sp500)

# check if stationary using kpss test
# H0 = stationary; p-value greater --> do not reject, p-value smaller --> reject
kpss.test(sp500)
plot(sp500)
# our data is now stationary so we can fit this into an auto.arima model and forecast
# an alternative would be to determine the model by looking at acf & pacf plots
auto_arima_fit = auto.arima(sp500)

# before forecasting make sure data is normal using shapiro test
# H0: samples come from normal dist
shapiro.test(auto_arima_fit$resid)

# p-value is very small --> data is normal
#forecast and plot results
fc = forecast(auto_arima_fit, 252)
plot(fc)

#S&P should be 2240 on the last closing day of 2016
