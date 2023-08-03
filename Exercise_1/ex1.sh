#!/bin/bash

# Function to check if a URL is valid
function is_valid_url() {
  if curl --output /dev/null --silent --head --fail "$1"; then
    return 0
  else
    return 1
  fi
}

# Function to check if the URL points to an image
function is_image_url() {
  local content_type
  content_type=$(curl -Is "$1" | grep -i "Content-Type" | awk '{print $2}')
  if [[ "$content_type" =~ image/* ]]; then
    return 0
  else
    return 1
  fi
}


# Validate the number of arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <Target_directory> "<Image_URL1>" ["<Image_URL2>" ...]"
  exit 1
fi

target_dir="$1"
shift

# Validate the target directory
if [ ! -d "$target_dir" ]; then
  echo "Target directory not found."
  exit 1
fi

# Create a directory for downloads
download_dir="$target_dir/downloads"
mkdir -p "$download_dir"

# Download images
valid_urls=0
while [ $# -gt 0 ]; do
  url="$1"
  if is_valid_url "$url" && is_image_url "$url"; then
    filename=$(basename "$url")
    curl -L "$url" --output "$download_dir/$filename"
    (( valid_urls++ ))
  else
    echo "Invalid image URL: $url"
  fi
  shift
done

if [[ valid_urls -gt 0 ]]; then
  # Create an archive with the current time in the filename
  archive_name="images_$(date +%Y%m%d%H%M%S).zip"
  zip -r "$archive_name" "$download_dir"
  echo "Images downloaded and archived as $archive_name."
  exit 0
else
  echo "All supplied images urls are invalid"
  exit 1
fi