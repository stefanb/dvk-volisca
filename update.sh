#!/bin/bash
set -e

BASEURL="https://www.dvk-rs.si/fileadmin/dvk_maps"
mkdir -p dvk

curl -s "${BASEURL}/notifications.json" | jq > dvk/notifications.json
curl -s "${BASEURL}/settings.json"      | jq > dvk/settings.json

# curl -s "${BASEURL}/volisca.csv.json"   | jq > dvk/volisca.csv.json
# jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/volisca.csv.json > dvk/volisca.csv

# curl -s "${BASEURL}/pg_volisca.csv.json"   | jq > dvk/pg_volisca.csv.json
# jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk/pg_volisca.csv.json > dvk/pg_volisca.csv

RpeApiBaseURL="https://dvk-rpe.transmedia-design.me/api"
mkdir -p dvk-rpe-api
curl -s "${RpeApiBaseURL}/polling_stations/?cid=1"   | jq > dvk-rpe-api/volisca-redna.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk-rpe-api/volisca-redna.json > dvk-rpe-api/volisca-redna.csv
curl -s "${RpeApiBaseURL}/polling_stations/?cid=2"   | jq > dvk-rpe-api/volisca-predcasna.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' dvk-rpe-api/volisca-predcasna.json > dvk-rpe-api/volisca-predcasna.csv

VolitveBASEURL="https://volitve.dvk-rs.si"
mkdir -p volitve

curl -s "${VolitveBASEURL}/config/config.json"   | jq > volitve/config.json
curl -s "${VolitveBASEURL}/data/obvestila.json"  | jq > volitve/obvestila.json
curl -s "${VolitveBASEURL}/data/data.json"       | jq > volitve/data.json
jq -r '(.slovenija.enote | map({st: .st, naziv: .naz} ))| (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/data.json > volitve/enote.csv
curl -s "${VolitveBASEURL}/data/liste.json"      | jq > volitve/liste.json
jq -r '(.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/liste.json > volitve/liste.csv
curl -s "${VolitveBASEURL}/data/kandidati.json"  | jq > volitve/kandidati.json
jq -r 'map({zap_st: .zap_st, st: .st, id: .id, ime: .ime, priimek: .pri, datum_rojstva: .dat_roj[0:10], delo: .del , obcina: .obc , naselje: .nas , ulica: .ul , hisna_st: .hst , enota: .enota, okraj_1: .okraji[0], okraj_2: .okraji[1] }) | (.[0] | to_entries | map(.key)), (.[] | [.[]]) | @csv' volitve/kandidati.json > volitve/kandidati.csv
curl -s "${VolitveBASEURL}/data/zgod_udel.json"  | jq > volitve/zgod_udel.json

# Iz navodil medijem:
# https://www.dvk-rs.si/volitve-in-referendumi/drzavni-zbor-rs/volitve-drzavnega-zbora-rs/volitve-v-dz-2022/#accordion-1731-body-6
curl -s "${VolitveBASEURL}/data/udelezba.json"            | jq > volitve/udelezba.json
curl -s "${VolitveBASEURL}/data/udelezba.csv"                  > volitve/udelezba.csv
curl -s "${VolitveBASEURL}/data/rezultati.json"           | jq > volitve/rezultati.json
curl -s "${VolitveBASEURL}/data/rezultati.csv"                 > volitve/rezultati.csv
curl -s "${VolitveBASEURL}/data/kandidati_rezultati.json" | jq > volitve/kandidati_rezultati.json
curl -s "${VolitveBASEURL}/data/mandati.csv"                   > volitve/mandati.csv


for VE in {1..8}
do
    VETEMP="0${VE}"
    VEPAD="${VETEMP: -2}" #pad left with 0s to max 2 chars
    for VO in {1..11}
    do
        VOTEMP="0${VO}"
        VOPAD="${VOTEMP: -2}"
        echo "Scraping VE:${VEPAD} VO:${VOPAD}..."
        curl -s "${VolitveBASEURL}/data/volisca_${VEPAD}_${VOPAD}.json" | jq > volitve/volisca_${VEPAD}_${VOPAD}.json
    done
done
