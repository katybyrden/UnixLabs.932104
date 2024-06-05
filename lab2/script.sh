#!/bin/bash -e

startPath="/data"
lockPath="/data/lockfile"
containerId=$(shuf -i 1-100000 -n 1) # generate numbers from 1 to 10e6 and pick 1

findFreeFileName() {
	local indexOfFile=1
	while true; do # we'll iterate from 0 to n until indexOfFile was not used
	    fileName=$(printf "%03d" $indexOfFile)
	    
	    if [ ! -e "$startPath/$fileName" ]; then    
	        echo "$fileName"
	        return
	    fi
	    
	    indexOfFile=$((indexOfFile + 1))
	done
}

while true; do
  (
  	flock -x 200 # write lock
  	
  	fileName=$(findFreeFileName)
	echo "Creating file $fileName"
	echo "Container ID: $containerId" > "$fileName"
	echo "File number: $((10#$fileName))" >> "$fileName"

  )200>"$lockPath"
  
  sleep 1
  	
  (
  	flock -x 200
  	
  	if [ -e "$startPath/$fileName" ]; then
  		rm -f "$startPath/$fileName"
  	fi
  )200<"$lockPath"
  
  sleep 1

done


