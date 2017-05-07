#!/bin/bash

error_tag="\e[1;41m ERROR \e[0m"

if [[ $# != 1 || ! -f $1 ]]; then
	echo -e $error_tag "Please provide a text file as an argument"
	exit 1
fi
path="$1"

separators=($(grep -n -e "^=\+$" "$path"))
if [[ ${#separators[@]} != 2 ]]; then
	echo -e $error_tag "The provided file does not contain the three required sections"
	exit 1
fi
for i in 0 1; do
	separators[$i]=${separators[$i]%%:*}
done

# Parameter expansion lookup table
#abc=a.b.c
#echo ${abc##*\.} # c
#echo ${abc#*\.}  # b.c
#echo ${abc%%\.*} # a
#echo ${abc%\.*}  # a.b

root_path=$(echo $path | sed "s/^\(.*\/Śpiewnik\/\).*$/\1/")
song_path=$(echo $path | sed "s/^.*\/Śpiewnik\/\(.*\)$/\1/")

if [[ -d $song_path ]]; then
	rm -r "$song_path"
fi
mkdir -p "$song_path"

song_title=$(head -n $((${separators[0]}-1)) "$path")
echo -e "\e[1;42m$song_title\e[0m"
song_text=$(tail -n +$((${separators[0]}+1)) "$path" | head -n $((${separators[1]}-${separators[0]}-1)))
#song_text=$(tail -n +$((${separators[0]}+1)) "$path" | head -n -$((${separators[1]}-${separators[0]}-1)))
echo -e "\e[1;43m$song_text\e[0m"
song_chords=$(tail -n +$((${separators[1]}+1)) "$path")
echo -e "\e[1;44m$song_chords\e[0m"
