#!/bin/sh

# ------------------------------------------------------------------
# [Author] Pratik Sahu
#          Hashkey generate from keystore file
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=hash
USAGE="Usage: hash.sh --package package_name --alias alias_name --keystore keystore_file"

# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

if [[ "$1" != "--package" ]]; then
  echo "Error: expected --package as first parameter"
  exit 1
fi
pkg="$2"
shift 2

if [[ "$1" != "--alias" ]]; then
  echo "Error: expected --alias as second parameter"
  exit 1
fi
ali="$2"
shift 2

if [[ "$1" != "--keystore" ]]; then
  echo "Error: expected --keystore as third parameter"
  exit 1
fi
keystore="$2"
shift 2



echo
echo "package name: $pkg"
echo "keystore file: $keystore"
echo 


if [ -e "$keystore" ]
then
  echo "File $keystore is found."
  echo
else
  echo "File $keystore is not found."
  echo
  exit 0;
fi

res=$(keytool -exportcert -alias $ali -keystore $keystore | xxd -p | tr -d "[:space:]" | echo -n $pkg `cat` | sha256sum | tr -d "[:space:]-" | xxd -r -p | base64 | cut -c1-11)
echo "HashKey: $res"
