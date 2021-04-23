
# NYEdData: Data for schools in New York State

### Building the package

``` r
library(devtools)

document()
install(dependencies = FALSE)

library(NYEdData)
ls('package:NYEdData')
data(package = 'NYEdData')

data("districts_enrollment")
data("schools_enrollment")

# Build data files
tools::resaveRdaFiles('data/')
```
