#!/bin/bash

if [ -z "$1" ]; then
  echo add filename in script args
  exit 1
fi

OUTPUT_FILE_NAME_STRING="$(grep -i "Output:" "$1")"
OUTPUT_FILE_NAME_WITH_WHITESPACE=${OUTPUT_FILE_NAME_STRING#//Output:}
OUTPUT_FILE_NAME=$(echo "$OUTPUT_FILE_NAME_WITH_WHITESPACE" | tr -d '[:space:]')

if [ -z "$OUTPUT_FILE_NAME" ]; then
  echo File name is not valid
  exit 1
fi

TEMP_FOLDER=$(mktemp -d)

trap "rm -Rf $TEMP_FOLDER; exit 1" 9 2 1 15
trap "rm -Rf $TEMP_FOLDER" EXIT

cp "$1" "$TEMP_FOLDER"/

CURRENT_DIR=$(pwd)

cd "$TEMP_FOLDER"

gcc "$1" -o "$OUTPUT_FILE_NAME"

if [ $? -ne 0 ]; then
  echo Compilation failed!
  cd "$CURRENT_DIR"
  exit 1
fi

mv "$OUTPUT_FILE_NAME" "$CURRENT_DIR"
cd "$CURRENT_DIR"
echo Building: "$OUTPUT_FILE_NAME"
exit 0
