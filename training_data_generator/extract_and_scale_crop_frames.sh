#!/bin/bash

commands=("ffmpeg" "mogrify")

for cmd in "${commands[@]}"; do
    if command -v "$1" >/dev/null 2>&1 "$cmd"; then
        continue
    else
        YELLOW='\033[1;33m'
        RESET='\033[0m'
        printf "\nA required command is missing."
        printf "\nThe required commands are:\n\n"
        for cmd in "${commands[@]}"; do
            printf "${YELLOW}$cmd${RESET}\t"
        done
        printf "\n\nPlease ensure all required commands are installed\n\n"
        exit 1
    fi
done

input_dir="./input_videos"
output_dir="./output_images"

scale_dimensions="225x400"
crop_dimensions="225x300+0+50"

mkdir -p "$output_dir"

for input_file in "$input_dir"/*.mp4; do
    if [ -f "$input_file" ]; then
        filename=$(basename -- "$input_file")
        filename_noext="${filename%.*}"

        ffmpeg -i "$input_dir/$filename" -vf fps=6 "$output_dir/$filename_noext"_%04d.png
    fi
done

for output_frame in "$output_dir"/*.png; do
    if [ -f "$output_frame" ]; then
        filename=$(basename -- "$output_frame")
        filename_noext="${filename%.*}"

        mogrify -resize "$scale_dimensions" -crop "$crop_dimensions" "$output_dir/$filename"
    fi
done

