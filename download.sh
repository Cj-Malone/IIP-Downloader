#!/usr/bin/env bash

while IFS="," read -r name filename url; do
	echo "$name"
	wget "$url" --output-document="data/$filename"
done < "local authorities.csv"

