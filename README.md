# Wales-ish OTP Graph Generator

This is a bunch to scripts to help assemble OpenTripPlanner graphs that are useable for planning trips, by car or public transport, between places in Wales - including where these trips involve a short journey entirely within England. (It likely also works well enough for planning trips between places in Wales and a small number of English towns just the other side of the border.)

The map below shows the train and bus stops included (as of June 2021), giving an idea of the region included:

![Map of train and bus stops covered by Wales-ish region](map.png)


## Features and Anti-Features

- Downloads English bus etc. open data from DfT GOV.UK
- Downloads OpenStreetMap data from geofabrik.de
- Downloads Welsh bus etc. data from Traveline (requires registration)
- Download heavy rail CIF from data.atoc.org (requires registration)
- Creates extracts of street and public transport data covering Wales and strip of the borders
- Covers Chester, Liverpool, Shrewsbury, Hereford, Bristol, Gloucester
- Doesn't cover Wolverhampton, Birmingham or most of Manchester

## Requirements
- R
- UK2GTFS R package
- osmium

## How-to

```R
devtools::load_all()
# Complete config.yml
download_atoc()
prepare_atoc_gtfs()
download_tnds()
prepare_tnds_gtfs()
download_and_prepare_bus_gtfs()
download_and_prepare_osm()
prepare_street_graph()
prepare_transport_graph()
# output/ should now contain streetGraph.obj and graph.obj
```
