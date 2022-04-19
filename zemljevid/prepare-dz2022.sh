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

# Poligoni
# curl -o VDV-GURS-RPE.geojson https://raw.githubusercontent.com/stefanb/gurs-rpe/master/data/VDV.geojson
# curl -o OB-GURS-RPE.geojson https://raw.githubusercontent.com/stefanb/gurs-rpe/master/data/OB.geojson

rm volisca-predcasno-dz2022-poligoni.geojson
ogr2ogr volisca-predcasno-dz2022-poligoni.geojson VDV-GURS-RPE.geojson -dialect sqlite \
 -sql "SELECT ST_Union(geometry),
		GROUP_CONCAT('- '|| dvk.OVK || ': ' || OVK_ime, char(10)) as ovk,
		dvk.name as 'name',
		dvk.sedez_naslov as 'address',
		dvk.sedez_posta as 'city'
	FROM 'VDV' AS src
		LEFT JOIN 'volisca-predcasno-dz2022.csv'.volisca-predcasno-dz2022 AS dvk ON cast(src.VDV_ID as text)=dvk.OVK
    WHERE src.ENOTA = 'VO'
    GROUP BY dvk.name, dvk.sedez_naslov, dvk.sedez_posta"\
 -nln VDV-GURS-RPE-DVK-Predcasno -overwrite


rm volisca-predcasno-dz2022-tocke-dvk-api.geojson
ogr2ogr -f "GeoJSON" volisca-predcasno-dz2022-tocke-dvk-api.geojson ../dvk-rpe-api/volisca-predcasna.csv \
	-a_srs 'EPSG:4326' \
	-oo X_POSSIBLE_NAMES=longitude \
	-oo Y_POSSIBLE_NAMES=latitude \
	-oo KEEP_GEOM_COLUMNS=NO \
	-lco RFC7946=YES \
	-nln DVK-API-predcasno-tocke

rm volisca-redno-dz2022-tocke-dvk-api.geojson
ogr2ogr -f "GeoJSON" volisca-redno-dz2022-tocke-dvk-api.geojson ../dvk-rpe-api/volisca-redna.csv \
	-a_srs 'EPSG:4326' \
	-oo X_POSSIBLE_NAMES=longitude \
	-oo Y_POSSIBLE_NAMES=latitude \
	-oo KEEP_GEOM_COLUMNS=NO \
	-lco RFC7946=YES \
	-nln DVK-API-redno-tocke

ogr2ogr volisca-redno-dz2022.geojson VDV-GURS-RPE.geojson -dialect sqlite \
 -sql "SELECT ST_Union(geometry),
		TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(VDV_UIME, '.', '. '), ',', ', '), ' U.', ' Ulica '), ' C.', ' Cesta '), ' Ul.', ' Ulica '), ' u.', ' ulica '), ' ul.', ' ulica '), ' c.', ' cesta '), ' d. o. o.', ' d.o.o.'), ' d. d.', ' d.d.'), ' s. p.', ' s.p.'), '. ,', '.,'), '   ', ' '), '  ', ' ')) as 'name',
		IFNULL(VDV_DJ, '') as 'name_alt',
		SUM(POV_KM2) as 'pov_km2',
		COUNT(sifra) as 'sifre_count',
		GROUP_CONCAT(sifra, ', ') as sifre_volisc
	FROM (
		SELECT N8 as sifra, VDV_UIME, VDV_DJ, POV_KM2, geometry
		FROM 'VDV'
		WHERE ENOTA = 'VD'
		ORDER BY sifra
	)
	GROUP BY LOWER(name)
	ORDER BY sifre_volisc"\
 -lco RFC7946=YES -lco WRITE_BBOX=YES \
 -nln VDV-GURS-RPE-Regular -overwrite

echo "  done."
