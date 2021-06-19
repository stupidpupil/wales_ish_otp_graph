This is a bunch to scripts to help assemble OpenTripPlanner graphs that are useable for planning trips, by car or public transport, between places in Wales.

# Features and Anti-Features

- Downloads bus etc. open data from DfT GOV.UK
- Downloads OpenStreetMap data from geofabrik.de
- Relies on you to download heavy rail CIF from data.atoc.org
- Creates extracts of street and public transport data covering Wales and strip of the borders
- Covers Chester, Liverpool, Shrewsbury, Hereford, Bristol, Gloucester
- Doesn't cover Wolverhampton, Birmingham or most of Manchester

# Requirements
- R
- UK2GTFS R package
- osmium

# How-to

```R
devtools::load_all()
# Download latest ATOC timetable data from data.atoc.org and move it to data-raw/atoc.zip
prepare_atoc_gtfs()
download_and_prepare_bus_gtfs()
download_and_prepare_osm()
prepare_street_graph()
prepare_transport_graph()

```