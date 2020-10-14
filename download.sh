#!/usr/bin/env bash

while IFS="," read -r name filename url; do
	dirname="${filename:0:-4}"

	echo "$name"

	if [ -f "data/$filename" ]; then
		echo "Skipping download"
	else
		wget "$url" --output-document="data/$filename"
	fi
	if [ -d "data/$dirname" ]; then
		echo "Skipping extraction"
	else
		unzip "data/$filename" -d "data/$dirname"
	fi
	if [ -f "data/$dirname.shp" ]; then
		echo "Skipping conversion"
	else
		ogr2ogr -f "ESRI Shapefile" "data/$dirname.shp" "data/$dirname/Land_Registry_Cadastral_Parcels.gml"
	fi
done < "local authorities.csv"

