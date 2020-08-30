#!/bin/sh

# jq, ffmpeg

fd=$1
files=($(ls $fd))
echo ${files[@]}

# 1. input

echo "" > input

jpgs=()

for f in ${files[@]}
do
  case $f in
    *.txt) file=$f ;;
    *.mp3) mp3=$f ;;
    *.jpg) jpgs+=($f) ;;
    *.jpeg) jpgs+=($f) ;;
  esac
done

file="$fd/$file"
mp3="$fd/$mp3"

atime=($(jq ".[].ATime" $file))
btime=($(jq ".[].BTime" $file))
# atime+=(${btime[${#btime[@]}-1]})

i=0

for time in ${atime[@]}
do
  if [ -n "$a" ]; then
    duration=`echo "$time" - "$a" | bc -l`
    echo "file $fd/${jpgs[$i]}" >> input
    echo "duration ${duration}" >> input
    ((i+=1))
  fi
  a=${time}
done

echo "file last-page.jpg" >> input
duration=`echo "${btime[${#btime[@]}-1]}" - "$a" | bc -l`
echo "duration ${duration}" >> input
echo "file last-page.jpg" >> input

# 2. images + mp3

ffmpeg -f concat -safe 0 -i input -i $mp3 -y -vf fps=10 -threads 2 -preset veryfast $fd/video.mp4
