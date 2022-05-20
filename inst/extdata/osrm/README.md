# Car Speeds
Car speeds are taken from the Department for Transport's 
[Journey Time Statistics: Notes Definitions](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853603/notes-and-definitions.pdf#page=6)
and reflect average traffic speeds on different types of roads in the "morning peak" between 7 and 10am in 2017.

The table below shows the speeds and how they're mapped on to [OpenStreetMap's `highway` tags](https://wiki.openstreetmap.org/wiki/Roads_in_the_United_Kingdom) in OSRM.

| DfT Type of Road                    | OSM `highway` Tags        | km/h | mph  |
|-------------------------------------|---------------------------|------|------|
| Motorway                            | motorway                  | 77.6 | 48.1 |
| A road                              | trunk, primary            | 43.2 | 26.8 |
| B road                              | secondary                 | 41.9 | 26.0 |
| Minor road                          | tertiary                  | 36.3 | 22.6 |
| Local street                        | unclassified, residential | 18.3 | 11.4 |
| Private road -<br>restricted access | service                   | 15.3 | 9.5  |

They were made available under the [OGL v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).