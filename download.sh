#!/usr/bin/env bash

mkdir --parents "data"

if [ -f "Land_Registry_Cadastral_Parcels.gfs" ]; then
	touch "Land_Registry_Cadastral_Parcels.gfs"
else
	echo "Land_Registry_Cadastral_Parcels.gfs missing"
	exit
fi

while IFS="," read -r name filename url; do
	shortname="${filename:0:-4}"

	echo "$name"

	if [ -f "data/$shortname.imported" ]; then
		echo "Skipping download"
	else
		wget "$url" --output-document="data/$filename"
	fi
	if [ -f "data/$shortname.imported" ]; then
		echo "Skipping conversion"
	else
		if [[ $shortname == [A-Z][A-Z][A-Z] ]]; then
			# Scotland datasets
			ogr2ogr -append -f SQLite -dialect SQLite -sql "SELECT geometry FROM ${shortname}_bng" -nln landreg combined.sqlite "/vsizip/data/$filename/${shortname}_bng.shp"
			touch "data/$shortname.imported"
		else
			# England & Wales datasets
			zip -ru "data/$filename" Land_Registry_Cadastral_Parcels.gfs
			ogr2ogr -append -f SQLite -dialect SQLite -sql "SELECT geometry FROM PREDEFINED" -nln landreg combined.sqlite "/vsizip/data/$filename/Land_Registry_Cadastral_Parcels.gml"
			touch "data/$shortname.imported"
		fi
	fi
done < "local authorities.csv"
