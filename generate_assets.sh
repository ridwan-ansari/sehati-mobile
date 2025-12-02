#!/bin/bash

# === CONFIG ===
ASSET_DIR="assets"
OUTPUT_FILE="lib/app/common/constants/app_assets.dart"

# === CEK FOLDER ===
if [ ! -d "$ASSET_DIR" ]; then
  echo "❌ Folder '$ASSET_DIR' tidak ditemukan!"
  exit 1
fi

# === MULAI GENERATE ===
echo "🚀 Membuat file $OUTPUT_FILE ..."
echo "// GENERATED CODE - DO NOT MODIFY BY HAND" > $OUTPUT_FILE
echo "// ignore_for_file: constant_identifier_names" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "class AppAssets {" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# === LOOP SETIAP SUBFOLDER ===
find "$ASSET_DIR" -type d | while read -r DIR; do
  # Lewati folder root (assets itu sendiri)
  if [ "$DIR" != "$ASSET_DIR" ]; then
    FOLDER_NAME=$(basename "$DIR")
    echo "  //---------------------- $FOLDER_NAME ------------------------" >> $OUTPUT_FILE

    # Loop semua file di folder ini
  find "$DIR" -maxdepth 1 -type f \( \
  -name "*.png" -o \
  -name "*.jpg" -o \
  -name "*.jpeg" -o \
  -name "*.svg" -o \
  -name "*.otf" -o \
  -name "*.ttf" -o \
  -name "*.json" -o \
  -name "*.mp3" \
\) | while read -r FILE; do

      FILE_NAME=$(basename "$FILE")              # contoh: Inter-Regular.otf
      NAME_WITHOUT_EXT="${FILE_NAME%.*}"         # contoh: Inter-Regular
      VAR_NAME=$(echo "$NAME_WITHOUT_EXT" | sed -E 's/[-_]+/ /g' | awk '{for(i=1;i<=NF;i++){ if(i==1){printf tolower(substr($i,1,1)) substr($i,2)} else {printf toupper(substr($i,1,1)) substr($i,2)}}}')
      echo "  static const String $VAR_NAME = '$FILE';" >> $OUTPUT_FILE
    done

    echo "" >> $OUTPUT_FILE
  fi
done

echo "}" >> $OUTPUT_FILE

# === SELESAI ===
echo "✅ app_assets.dart berhasil dibuat di $OUTPUT_FILE"
