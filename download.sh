#!/usr/bin/env bash

while IFS="," read -r name filename url; do
	echo "$name"
	wget "$url" --output-document="data/$filename"
	dirname="${filename:0:-4}"
	unzip "data/$filename" -d "data/$dirname"
done < "local authorities.csv"

