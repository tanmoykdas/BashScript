#!/bin/bash

INPUT_DIR="/home/tanmoy/Videos"
OUTPUT_DIR="/home/tanmoy/Videos/low_quality"

mkdir -p "$OUTPUT_DIR"

echo "🔍 Looking for MP4 files in: $INPUT_DIR"
echo "📂 Output directory: $OUTPUT_DIR"

count=0
for f in "$INPUT_DIR"/*.mp4; do
  # Skip if the file doesn't exist or is in the output directory
  if [ ! -f "$f" ] || [[ "$f" == *"/low_quality/"* ]]; then
    continue
  fi
  
  filename=$(basename "$f")
  output_file="$OUTPUT_DIR/low_$filename"
  
  # Skip if already processed
  if [ -f "$output_file" ]; then
    echo "⏭️  Skipping (already exists): $filename"
    continue
  fi
  
  echo "🎬 Processing ($((count+1))): $filename"
  
  ffmpeg -i "$f" \
    -b:v 1200k \
    -b:a 96k \
    -preset medium \
    -y \
    "$output_file" 2>&1 | grep -E "(Duration|time=|error|Error)"
  
  if [ $? -eq 0 ]; then
    echo "✅ Completed: $filename"
    count=$((count+1))
  else
    echo "❌ Failed: $filename"
  fi
done

if [ $count -eq 0 ]; then
  echo "⚠️  No new videos processed."
else
  echo "✅ Processed $count video(s) successfully!"
fi
