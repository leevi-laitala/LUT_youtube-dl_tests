#!/bin/bash

echo "Jee :DDD"

mkdir out && cd out || exit 1

$YTEXEC -o "jee" "https://www.youtube.com/watch?v=y-E7_VHLvkE"

cd .. || exit 1

rm -rf out
