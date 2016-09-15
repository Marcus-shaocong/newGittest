#!/bin/bash

# Example of export an variable

declare -x var="outer"
echo "outer before:$var"
./inner.sh
echo "outer after :$var"
