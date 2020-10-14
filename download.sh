#!/usr/bin/env bash

while IFS="," read -r name filename url; do
	echo "$name"
	wget "$url" --output-document="data/$filename"
	dirname="${filename:0:-4}"
	unzip "data/$filename" -d "data/$dirname"
	ogr2ogr -f "ESRI Shapefile" "data/$dirname.shp" "data/$dirname/Land_Registry_Cadastral_Parcels.gml"
done < "local authorities.csv"

