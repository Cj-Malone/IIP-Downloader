#!/usr/bin/env bash

mkdir "data"

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
		cp Land_Registry_Cadastral_Parcels.gfs "data/$dirname/Land_Registry_Cadastral_Parcels.gfs"
		ogr2ogr -append -f SQLite -dialect SQLite -sql "SELECT geometry FROM PREDEFINED" combined.sqlite "data/$dirname/Land_Registry_Cadastral_Parcels.gml"
	fi
done < "local authorities.csv"

