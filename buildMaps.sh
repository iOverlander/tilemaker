#!/bin/bash

# Check if filename is provided 
# this is a list of all the areas for offline maps - each gets its own .mbtiles file
if [ $# -eq 0 ]; then
    filename="areas.txt"
elif [ $# -eq 1 ]; then
filename="$1"
else
    echo "Usage: $0 [filename]"
    exit 1
fi

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
    exit 1
fi


# download landcover layers and coastline to be included in the maps
./get-coastline.sh
./get-landcover.sh



# Read areas into a list to process through them
mapfile -t my_array < "$filename"

# Loop through each value in the array
for value in "${my_array[@]}"; do

    echo "Processing: osms/${value}.osm.pbf"
    echo "outputting to: data/${value}.mbtiles"

    # Create directory for output if it doesn't exist
    output_dir=$(dirname "data/${value}.mbtiles")
    mkdir -p "$output_dir"
    
    tilemaker --input "osms/${value}.osm.pbf" \
            --output "data/${value}.mbtiles" \
            --config resources/config-openmaptiles.json \
            --process resources/process-openmaptiles.lua \
            --fast
    
done



# tilemaker --input 'osms/africa/algeria.osm.pbf' \
#             --output 'data/africa/algeria.mbtiles' \
#             --config resources/config-openmaptiles.json \
#             --process resources/process-openmaptiles.lua \
#             --fast

#     tilemaker --input "osms/${value}.osm.pbf" \
#             --output "data/${value}.mbtiles" \
#             --config resources/config-openmaptiles.json \
#             --process resources/process-openmaptiles.lua \
#             --fast

# time tilemaker --input osms/planet_optimized.osm.pbf \
#             --output data/planet_basemap.mbtiles \
#             --config resources/config-openmaptiles.json \
#             --process resources/process-openmaptiles.lua \
#             --fast


# time tilemaker --input osms/north-america/us/washington.osm.pbf \
#             --output data/washington.mbtiles \
#             --config resources/config-openmaptiles.json \
#             --process resources/process-openmaptiles.lua \
#             --fast