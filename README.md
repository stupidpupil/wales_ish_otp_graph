---
output:
  html_document:
    theme: united
    toc: true
  md_document:
    variant: gfm
title: Wales-ish OpenTripPlanner Graph
---

You can [download the latest release of the Wales-ish OTP graph
here](https://github.com/stupidpupil/wales_ish_otp_graph/releases/latest).

## Update

The graph file was last updated at 10:25 BST on 28 June 2021.

It was prepared using the following version of OpenTripPlanner -
`2.1.0-SNAPSHOT, ser.ver.id: 8, commit: 6aebf2927b11be1f005c8db1041e66a2d8e884ec, branch: dev-2.x`
- running on the following version of Java -
`openjdk 16.0.1 2021-04-20`.

## License

The *graph.obj* graph file is made available under the [ODbL
v1.0](https://opendatacommons.org/licenses/odbl/1-0/) by Adam Watkins as
part of the [Wales-ish OTP graph
project](https://stupidpupil.github.io/wales_ish_otp_graph).

The graph file contains:

-   street map information obtained from [OpenStreetMap
    contributors](https://www.openstreetmap.org/copyright), via
    [Geofabrik.de](https://download.geofabrik.de/europe/great-britain.html),
    under the [ODbL
    v1.0](https://opendatacommons.org/licenses/odbl/1-0/),
-   heavy rail timetable information obtained from [RSP Limited (Rail
    Delivery Group)](http://data.atoc.org/) under the [CC-BY
    v2.0](https://creativecommons.org/licenses/by/2.0/uk/legalcode), and
-   bus and other public transport services timetable information
    obtained from
    [Traveline](https://www.travelinedata.org.uk/traveline-open-data/traveline-national-dataset/)
    and the [UK Department for
    Transport](https://data.bus-data.dft.gov.uk/) under the [OGL
    v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

The graph file is provided without any warranty of any kind and without
any endorsement by any of the individuals or organisations named above,
for any purpose.

If you provide a routing service or similar using the graph file you
should make sure that the above attributions are stated clearly. If you
produce a set of routing instructions using such a routing service,
these likely form a “derived database” and should also be provided under
the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/), again
with the attributions above attached.

*otp.jar* is a copy of the version of
[OpenTripPlanner](https://github.com/opentripplanner/OpenTripPlanner)
used to generate the graph file; it is released under the [LGPL v3.0 (or
later)](https://opensource.org/licenses/LGPL-3.0). Again, it is provided
without any warranty of any kind and without any endorsement, for any
purpose.
