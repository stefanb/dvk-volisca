#!/bin/bash
set -e

BASEURL="https://www.dvk-rs.si/fileadmin/dvk_maps"
mkdir -p dvk

curl -s "${BASEURL}/notifications.json" | jq > dvk/notifications.json
curl -s "${BASEURL}/settings.json"      | jq > dvk/settings.json

curl -s "${BASEURL}/volisca.csv.json"   | jq > dvk/volisca.csv.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/volisca.csv.json > dvk/volisca.csv

curl -s "${BASEURL}/pg_volisca.csv.json"   | jq > dvk/pg_volisca.csv.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/pg_volisca.csv.json > dvk/pg_volisca.csv


VolitveBASEURL="https://volitve.dvk-rs.si"
mkdir -p volitve

curl -s "${VolitveBASEURL}/config/config.json"   | jq > volitve/config.json
curl -s "${VolitveBASEURL}/data/obvestila.json"  | jq > volitve/obvestila.json
curl -s "${VolitveBASEURL}/data/data.json"       | jq > volitve/data.json
jq -r '(.slovenija.enote | map({st: .st, naziv: .naz} ))| (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/data.json > volitve/enote.csv
curl -s "${VolitveBASEURL}/data/liste.json"      | jq > volitve/liste.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/liste.json > volitve/liste.csv
curl -s "${VolitveBASEURL}/data/kandidati.json"  | jq > volitve/kandidati.json
jq -r 'map({zap_st: .zap_st, st: .st, ime: .ime, priimek: .pri, datum_rojstva: .dat_roj[0:10], delo: .del , obcina: .obc , naselje: .nas , ulica: .ul , hisna_st: .hst , enota: .enota, okraj_1: .okraji[0], okraj_2: .okraji[1] }) | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/kandidati.json > volitve/kandidati.csv
curl -s "${VolitveBASEURL}/data/zgod_udel.json"  | jq > volitve/zgod_udel.json


