# Wales-ish OTP Graph Generator

This is a bunch to scripts to help assemble OpenTripPlanner graphs that are useable for planning trips, by car or public transport, between places in Wales - including where these trips involve a short journey entirely within England. (It likely also works well enough for planning trips between places in Wales and a small number of English towns just the other side of the border.)

[See the GitHub page for this repository for releases of graphs produced by this script](https://stupidpupil.github.io/wales_ish_otp_graph/).

### Coverage
- Creates extracts of street and public transport data covering Wales and a strip of the borders
- Covers Chester, Crewe, Liverpool, Shrewsbury, Hereford, Bristol, Gloucester
- Doesn't cover Wolverhampton, Birmingham or most of Manchester

## Requirements
- R
- [Java 17](https://adoptium.net)
- [osmium](https://osmcode.org/osmium-tool/)


## Licence of outputs

Outputs include data derived from the following sources:

| Data                       | License                                                                             | Source                                   |
|----------------------------|-------------------------------------------------------------------------------------|------------------------------------------|
| ATOC Heavy Rail Timetables | [CC-BY-2.0](https://creativecommons.org/licenses/by/2.0/uk/legalcode)    | RSP Limited (Rail Delivery Group)                              |
| DfT Bus Open Data Service (BODS) | [OGL-UK-3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) | Department for Transport (UK Government)  |
| Traveline National Data Set (TNDS) | [OGL-UK-3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) | Traveline  |
| OpenStreetMap data         | [ODbL-1.0](https://opendatacommons.org/licenses/odbl/)                                  | OpenStreetMap contributors, Geofabrik.de |
| Terrain 50 elevation data  | [OGL-UK-3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) | Ordnance Survey                      |

