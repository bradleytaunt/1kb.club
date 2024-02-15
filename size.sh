#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

folder_path=$1

# Timeout value in seconds (adjust as needed)
url_timeout=10

# Loop through each markdown file in the specified folder
for file in "$folder_path"/*.md; do
    if [ -f "$file" ]; then
        # Extract URL from "pageurl:" YAML
        url=$(grep "pageurl:" "$file" | awk '{print $2}')

        if [ -n "$url" ]; then
            download_dir=$(mktemp -d)

            # Use curl with timeout to download the page and its resources, redirecting logs to /dev/null
            if gtimeout "$url_timeout" curl -L --create-dirs --output "$download_dir/index.html" "$url" > /dev/null 2>&1; then
                # Display the size of each downloaded resource
                echo "Resource sizes for $url:"
                total_size_bytes=0

                # Iterate over files directly in the temporary download directory
                for resource_file in "$download_dir"/*; do
                    if [ -f "$resource_file" ]; then
                        size_bytes=$(stat -f%z "$resource_file")
                        total_size_bytes=$((total_size_bytes + size_bytes))
                        echo "$resource_file: $size_bytes bytes"
                    fi
                done

                # Convert total size to kilobytes
                total_size_kb=$((total_size_bytes / 1024))

                # Update the "size:" YAML with the total size
                awk -v total_size_bytes="$total_size_bytes" '/size:/ {sub(/size:.*/, "size: " total_size_bytes)} 1' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

                # Clean up the temporary download directory
                rm -r "$download_dir"

                echo "Total size of all resources updated in $file: $total_size_kb kilobytes"
            else
                echo "Error: Timeout while checking URL in $file"
            fi
        else
            echo "Error: URL not found in $file"
        fi
    fi
done
