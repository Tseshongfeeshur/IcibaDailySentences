#!/bin/bash

mkdir mydir
curl "https://sentence.iciba.com/index.php?c=dailysentence&m=getTodaySentence" > mydir/iciba.json
jq .title mydir/iciba.json -r > mydir/tmp.txt
read -r date < mydir/tmp.txt
jq .content mydir/iciba.json -r > mydir/tmp.txt
read -r en < mydir/tmp.txt
jq .note mydir/iciba.json -r > mydir/tmp.txt
read -r cn < mydir/tmp.txt
jq .picture2 mydir/iciba.json -r > mydir/tmp.txt
read -r pic < mydir/tmp.txt
jq .tts mydir/iciba.json -r > mydir/tmp.txt
read -r speak < mydir/tmp.txt
mkdir output
echo "{\"Date\":\"${date}\",\"InEnglish\":\"${en}\",\"InChinese\":\"${cn}\",\"Picture\":\"${pic}\",\"Speaking\":\"${speak}\"}" | jq . > output/info.json
curl "${pic}" -o output/picture.jpg
curl "${speak}" -o output/speaking.mp3
mkdir temp
cd temp
git init
git remote add origin git@github.com:Tseshongfeeshur/IcibaDailySentences.git
git fetch
git checkout -b gh-pages
cp -a -f "../output/." "."
cp -f "../page.html" "index.html"
cp -f "../page.html" "404.html"
git add .
git commit -m "Update"
git push -f origin gh-pages
