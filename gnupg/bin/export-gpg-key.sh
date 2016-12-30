#!/usr/bin/env bash

if [ $# -lt 2 ]
then
   echo "$0 keyid keyname"
   exit 1
fi

N=2 # number of QR codes to generate
KEYID=$1
KEYNAME=$2

# check that required programs are installed
for PRG in gpg paperkey qrencode epstopdf pdfjam
do
   command -v $PRG >/dev/null 2>&1 || { echo >&2 "$PRG not installed."; exit 1; }
done

TMP=$(mktemp -d)
pushd $TMP

# export and compress secret key
gpg --export-secret-keys $KEYID | paperkey --output-type raw | base64 > $KEYNAME.txt

# split key into N files and encode as QR codes
for i in $(seq -w $N)
do
   split -n $i/$N $KEYNAME.txt | qrencode -t eps -o $KEYNAME-$i.eps
done

# convert EPS to PDF
find -maxdepth 1 -type f -iname '*.eps' | xargs -L1 epstopdf

# assemble PDFs into single PDF (two pages per page)
pdfjam $KEYNAME-*.pdf --nup 2x1 --landscape --outfile $KEYNAME.pdf

popd
cp $TMP/$KEYNAME.pdf .
