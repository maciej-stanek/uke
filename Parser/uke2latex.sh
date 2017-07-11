#!/bin/bash

## Process args
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

## Parameter expansion lookup table
#abc=a.b.c
#echo ${abc##*\.} # c
#echo ${abc#*\.}  # b.c
#echo ${abc%%\.*} # a
#echo ${abc%\.*}  # a.b

## Prepare output path for LaTeX section
song_path=$(echo $path | sed "s/^.*\/Śpiewnik\/\(.*\)$/generated_latex\/\1/")
song_path=$(echo ${song_path,,} | tr ' ' '_' | tr -c -d "[:alpha:]\/_").tex
echo "song_path=$song_path"
echo "song_path%/*=${song_path%\/*}"
if [[ -f $song_path ]]; then
	rm $song_path
fi
mkdir -p "${song_path%\/*}"
touch $song_path

## Extract three sections of the file
song_title=$(head -n $((${separators[0]}-1)) "$path")
#echo -e "\e[1;42m$song_title\e[0m"
song_text=$(tail -n +$((${separators[0]}+1)) "$path" | head -n $((${separators[1]}-${separators[0]}-1)))
#echo -e "\e[1;43m$song_text\e[0m"
song_chords=$(tail -n +$((${separators[1]}+1)) "$path" | grep -v '^$')
#echo -e "\e[1;44m$song_chords\e[0m"

## Generate LaTeX section
echo "\marginnote{" >> $song_path
while read -r chord; do
	chord_array=($chord)
	## Draw chord image
	if [[ ! -f generated_chords/${chord_array[0]}.png ]]; then
		./chord2png.sh $chord
	fi
	chord_name=$(echo "${chord_array[0]}" | sed "s/#/\\\string##/g")
	echo "chord_name=$chord_name"
	echo "  \includegraphics[width=\marginparwidth]{generated_chords/$chord_name.png}" >> $song_path
done <<< "$song_chords"
echo "}[15mm]" >> $song_path
echo "\section{$song_title}" >> $song_path
echo "\begin{verbatim}$song_text\end{verbatim}" >> $song_path
echo "\newpage" >> $song_path

