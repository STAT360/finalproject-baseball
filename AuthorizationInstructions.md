Authorization Information
================

# Login Information for Google Sheets File

``` r
#email: USTBaseball1885@gmail.com
#password: GoTommies!
```

# Generating OAuth token for server using httr

When you try running the application, a webpage will pop-up with the
following message:

``` r
#Chrome: This site can't be reached; localhost refused to connect.
#Firefox: Unable to connect; can't establish a connection.
```

First, install the googlesheets and httr package in your console.

``` r
install.packages("googlesheets")
install.packages("httr")
```

You must create a .httr-oauth token from the server. After typing in the
following code into the console:

``` r
library(googlesheets) 
options(httr_oob_default=TRUE) 
gs_auth(new_user = TRUE) 
```

You will be given a URL to click on and given a authorization code in
return. Paste this authorization code into the console where prompted.
Your console will look like something similar to the following:

``` r
# > gs_auth(new_user = TRUE)
# No token currently in force.
# Please point your browser to the following url: 

# https://accounts.google.com/o/oauth2/auth?client_id=178989665258-
# f4scmimctv2o96isfppehg1qesrpvjro.apps.googleusercontent.com&scope=h
# ttps%3A%2F%2Fspreadsheets.google.com%2Ffeeds%20https%3A%2F%2Fwww.google
# apis.com%2Fauth%2Fdrive&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%
# 3Aoob&response_type=code

# Enter authorization code:
```

For more instructions go to the following website:
<https://support.rstudio.com/hc/en-us/articles/217952868-Generating-OAuth-tokens-for-a-server-using-httr>
