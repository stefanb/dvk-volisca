#!/bin/bash

geocodecsv -addressCol 5 -zipCol 6 -in volisca-omnia-dz2022.csv -out volisca-omnia-dz2022-geocoded.csv
rm volisca-omnia-dz2022-tocke.geojson
ogr2ogr -f "GeoJSON" volisca-omnia-dz2022-tocke.geojson volisca-omnia-dz2022-geocoded.csv \
	-a_srs 'EPSG:4326' \
	-oo X_POSSIBLE_NAMES=lon \
	-oo Y_POSSIBLE_NAMES=lat \
	-oo KEEP_GEOM_COLUMNS=NO \
	-lco RFC7946=YES \
	-nln VDV-GURS-RPE-DVK-OMNIA-tocke

geocodecsv -addressCol 9 -zipCol 10 -in volisca-predcasno-dz2022.csv -out volisca-predcasno-dz2022-geocoded.csv
rm volisca-predcasno-dz2022-tocke.geojson
ogr2ogr -f "GeoJSON" volisca-predcasno-dz2022-tocke.geojson volisca-predcasno-dz2022-geocoded.csv \
	-a_srs 'EPSG:4326' \
	-oo X_POSSIBLE_NAMES=lon \
	-oo Y_POSSIBLE_NAMES=lat \
	-oo KEEP_GEOM_COLUMNS=NO \
	-lco RFC7946=YES \
	-nln VDV-GURS-RPE-DVK-Predcasno-tocke

echo "  done."
