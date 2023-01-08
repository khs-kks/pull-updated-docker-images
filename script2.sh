#!/bin/bash

# This script uses curl instead of wget

# Set the names of the images and tags
images=(image1 image2 image3 image4 image5 image6 image7 image8 image9 image10)
tags=(latest latest latest latest latest latest latest latest latest latest)

# Loop through the images and tags
for i in "${!images[@]}"; do
  image=${images[$i]}
  tag=${tags[$i]}

  # Get the current version of the image
  current_version=$(docker inspect --format '{{ index .RepoTags 0 }}' "${image}:${tag}")

  # Get the latest version of the image using curl
  latest_version=$(curl -s "https://registry.hub.docker.com/v1/repositories/${image}/tags" | jq -r ".[] | select(.name == \"${tag}\") | .name")

  # If the latest version is different than the current version, pull the latest version
  if [[ "${latest_version}" != "${current_version}" ]]; then
    docker pull "${image}:${latest_version}"
  fi
done
