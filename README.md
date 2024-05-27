<img src="map.png" style="float:right;" data-external="1" />

This is an OpenTripPlanner network graph for planning trips, by car or public transport, between places in Wales - including where these trips involve a short journey entirely within England. (It likely also works well enough for planning trips between places in Wales and a small number of English towns just the other side of the border.)

The map shows bus and train routes included in the latest graph, giving a rough idea of the region included.

## How to use this

The graph file was last updated at 08:16 BST on 27 May 2024. (The graph should update weekly.)

[Download the latest release of the Wales-ish OTP graph here](https://github.com/stupidpupil/wales_ish_otp_graph/releases/latest). You’ll need to download the *otp_and_graph.zip* asset.

You can then start OpenTripPlanner using *run-otp.bat* (under Windows) or *run-otp.sh* (under Linux or macOS). Eventually it’ll print “Started listener bound to \[0.0.0.0:8080\]” and you’ll be able to access the planner at `http://localhost:8080` .

(You’ll need [install Java 21](https://adoptium.net). See the [OTP documentation](http://docs.opentripplanner.org/en/latest/) for more information.)

You can [see the code used to download source data and generate this graph here](https://github.com/stupidpupil/wales_ish_otp_graph).

## License

The *graph.obj* graph file is made available under the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/) by Adam Watkins as part of the [Wales-ish OTP graph project](https://stupidpupil.github.io/wales_ish_otp_graph).

The graph file contains:

- street map information obtained from [OpenStreetMap contributors](https://www.openstreetmap.org/copyright), via [Geofabrik.de](https://download.geofabrik.de/europe/great-britain.html), under the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/),
- heavy rail timetable information obtained from [RSP Limited (Rail Delivery Group)](http://data.atoc.org/) under the [CC-BY v2.0](https://creativecommons.org/licenses/by/2.0/uk/legalcode), and
- bus and other public transport services timetable information obtained from [Traveline](https://www.travelinedata.org.uk/traveline-open-data/traveline-national-dataset/) and the [UK Department for Transport](https://data.bus-data.dft.gov.uk/) under the [OGL v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
- [*Terrain 50* topology data](https://www.ordnancesurvey.co.uk/business-government/products/terrain-50) obtained from Ordnance Survey under the [OGL v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) (Contains OS data © Crown copyright and database right 2022).

The graph file is provided without any warranty of any kind and without any endorsement by any of the individuals or organisations named above, for any purpose.

If you provide a routing service or similar using the graph file you should make sure that the above attributions are stated clearly. If you produce a set of routing instructions using such a routing service, these likely form a “derived database” and should also be provided under the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/), again with the attributions above attached.

*otp.jar* is a copy of the version of [OpenTripPlanner](https://github.com/opentripplanner/OpenTripPlanner) used to generate the graph file; it is released under the [LGPL v3.0 (or later)](https://github.com/opentripplanner/OpenTripPlanner/blob/dev-2.x/LICENSE). Again, it is provided without any warranty of any kind and without any endorsement, for any purpose.

## Thanks

This project developed out of a [NHS Welsh Modelling Collaborative](https://twitter.com/nhswmc) hackathon, with the support of colleagues across NHS Wales including James Cooke of the Welsh Ambulance Service.

It depends entirely on the work done by [OpenStreetMap contributors](https://www.openstreetmap.org/), [Malcolm Morgan (University of Leeds, Institute for Transport Studies) and UK2GTFS contributors](https://itsleeds.github.io/UK2GTFS/), [Traveline](https://www.travelinedata.org.uk/), the [*osmium* developers](https://osmcode.org/), and of course the [OpenTripPlanner developers](http://www.opentripplanner.org/).

Important inspiration included the [*graphite* project](https://github.com/datasciencecampus/graphite) produced as part of [a piece of work by the ONS Data Campus](https://datasciencecampus.ons.gov.uk/access-to-services-using-multimodal-transport-networks/). Also of note is the [*OTP4GB* project](https://github.com/odileeds/OTP4GB) and [other work by ODI Leeds](https://odileeds.org/blog/2021-06-08-transportaccessibilityinnorthengland).
