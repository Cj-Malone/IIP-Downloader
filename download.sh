#!/usr/bin/env bash

mkdir --parents "data"

while IFS="," read -r name filename url; do
	shortname="${filename:0:-4}"

	echo "$name"

	if [ -f "data/$filename" ]; then
		echo "Skipping download"
	else
		wget "$url" --output-document="data/$filename"
	fi	
	if [ -f "data/$shortname.imported" ]; then
		echo "Skipping conversion"
	else
		if [[ $shortname == [A-Z][A-Z][A-Z] ]]; then
			# Scotland datasets
			ogr2ogr -append -f SQLite -dialect SQLite -sql "SELECT geometry FROM ${shortname}_bng" combined.sqlite "/vsizip/data/$filename/${shortname}_bng.shp"
			touch "data/$shortname.imported"
		else
			# England datasets
			zip -ru "data/$filename" Land_Registry_Cadastral_Parcels.gfs
			ogr2ogr -append -f SQLite -dialect SQLite -sql "SELECT geometry FROM PREDEFINED" combined.sqlite "/vsizip/data/$filename/Land_Registry_Cadastral_Parcels.gml"
			touch "data/$shortname.imported"
		fi
	fi
done < "local authorities.csv"
