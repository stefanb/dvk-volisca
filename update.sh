#!/bin/bash
set -e

BASEURL="https://www.dvk-rs.si/fileadmin/dvk_maps"
mkdir -p dvk

curl -s "${BASEURL}/notifications.json" | jq --sort-keys > dvk/notifications.json
curl -s "${BASEURL}/settings.json"      | jq --sort-keys > dvk/settings.json

curl -s "${BASEURL}/volisca.csv.json"   | jq --sort-keys > dvk/volisca.csv.json
jq -r 'map({id: .id, name: .name, address: .address, description: .description, lat: .lat, lon: .lon }) | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/volisca.csv.json > dvk/volisca.csv

curl -s "${BASEURL}/pg_volisca.csv.json"   | jq --sort-keys > dvk/pg_volisca.csv.json
jq -r 'map({id: .id, name: .name, address: .address, description: .description, lat: .lat, lon: .lon }) | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/pg_volisca.csv.json > dvk/pg_volisca.csv
