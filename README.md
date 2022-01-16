# Wales-ish OTP Graph Generator

This is a bunch to scripts to help assemble OpenTripPlanner graphs that are useable for planning trips, by car or public transport, between places in Wales - including where these trips involve a short journey entirely within England. (It likely also works well enough for planning trips between places in Wales and a small number of English towns just the other side of the border.)

[See the GitHub page for this repository for releases of graphs produced by this script](https://stupidpupil.github.io/wales_ish_otp_graph/).

## Features and Anti-Features

- Downloads OpenStreetMap data from geofabrik.de
- Downloads Welsh bus etc. data from Traveline (requires registration)
- Download heavy rail CIF from data.atoc.org (requires registration)
- Downloads English bus etc. open data from DfT GOV.UK
- Does some basic checking of a small number of test journeys
- Includes a Github Actions workflow with parallelisation and caching

### Default Coverage
- Creates extracts of street and public transport data covering Wales and a strip of the borders
- Covers Chester, Crewe, Liverpool, Shrewsbury, Hereford, Bristol, Gloucester
- Doesn't cover Wolverhampton, Birmingham or most of Manchester

## Requirements
- R
- [OpenJDK 11](https://adoptium.net/?variant=openjdk11)
- [osmium](https://osmcode.org/osmium-tool/)

## How-to

```R
devtools::install_github("stupidpupil/WalesIshOTPGraph")
library(WalesIshOTPGraph)

# Complete config.yml
check_config_and_environment()

download_atoc()
prepare_atoc_gtfs()
download_tnds()
prepare_tnds_gtfs()
download_and_prepare_bods_gtfs()
download_and_prepare_osm()

# OpenTripPlanner
download_otp()
prepare_street_graph()
prepare_transport_graph()

# r5r
prepare_r5r_network_dat()

# output/ should now contain graph.obj
```
## Licence of outputs

Outputs include data derived from the following sources:

| Data                       | License                                                                             | Source                                   |
|----------------------------|-------------------------------------------------------------------------------------|------------------------------------------|
| ATOC Heavy Rail Timetables | [CC-BY-2.0](https://creativecommons.org/licenses/by/2.0/uk/legalcode)    | RSP Limited (Rail Delivery Group)                              |
| DfT Bus Open Data Service (BODS) | [OGL-UK-3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) | Department for Transport (UK Government)  |
| Traveline National Data Set (TNDS) | [OGL-UK-3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) | Traveline  |
| OpenStreetMap data         | [ODbL-1.0](https://opendatacommons.org/licenses/odbl/)                                  | OpenStreetMap contributors, Geofabrik.de |


