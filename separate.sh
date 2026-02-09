#!/bin/bash

INPUT_DIR="/home/tanmoy/Videos/low_quality/"
OUTPUT_DIR="/home/tanmoy/Videos/Separated"

VIDEO_OUT="$OUTPUT_DIR/video_only"
AUDIO_OUT="$OUTPUT_DIR/audio_only"

echo "=================================="
echo "Starting video/audio separation..."
echo "=================================="
echo "Creating output directories..."
mkdir -p "$VIDEO_OUT" "$AUDIO_OUT"
echo "Directories created: $VIDEO_OUT and $AUDIO_OUT"
echo ""

count=0
skipped=0
total=$(ls -1 "$INPUT_DIR"/*.mp4 2>/dev/null | wc -l)

for f in "$INPUT_DIR"/*.mp4; do
    count=$((count + 1))
    filename=$(basename "$f")
    name="${filename%.*}"

    video_file="$VIDEO_OUT/${name}_video.mp4"
    audio_file="$AUDIO_OUT/${name}_audio.mp3"

    # Check if both files already exist
    if [ -f "$video_file" ] && [ -f "$audio_file" ]; then
        echo "[$count/$total] ⊘ Skipping: $filename (already converted)"
        skipped=$((skipped + 1))
        continue
    fi

    echo "[$count/$total] Processing: $filename"
    
    # Extract video only (no audio)
    echo "  → Extracting video track..."
    ffmpeg -i "$f" -an -c:v copy "$video_file" -loglevel error -stats
    echo "  ✓ Video saved: ${name}_video.mp4"

    # Extract audio only
    echo "  → Extracting audio track..."
    ffmpeg -i "$f" -vn -c:a libmp3lame -q:a 2 "$audio_file" -loglevel error -stats
    echo "  ✓ Audio saved: ${name}_audio.mp3"
    echo ""
done

echo "=================================="
echo "✓ All files processed successfully!"
echo "✓ Total files: $count"
echo "✓ Files converted: $((count - skipped))"
echo "✓ Files skipped: $skipped"
echo "✓ Output directory: $OUTPUT_DIR"
echo "=================================="
