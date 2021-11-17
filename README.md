# Wales-ish OTP Graph Generator - Autoregion Branch

## Requirements
You need [osmium-tool](https://osmcode.org/osmium-tool/) installed and in your PATH.


## How-to

Download the *autoregion* branch. Everything else _should_ be covered in the DESCRIPTION file…

```R
devtools::load_all()
# Complete config.yml - see config.yml.example
download_atoc()
prepare_atoc_gtfs()
download_and_prepare_bods_gtfs()
download_and_prepare_osm()
prepare_street_graph()
prepare_transport_graph()
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


