#!/bin/bash

## TODO: Implement grouping songs into categories (in the same fashion as in dirs)

while read -r song; do
	echo "$song"
	./uke2latex.sh "$song"
done <<< "$(find ../Śpiewnik -type f)"

template=songbook_template.tex
index=$(grep -n -e "^UKULELE\+$" $template | sed "s/^\([^:]\+\):UKULELE$/\1/")

generated=generated_songbook.tex
head -n $((index-1)) $template > $generated
while read -r tex; do
	cat $tex >> $generated
done <<< "$(find generated_latex -type f | sort)"
tail -n +$((index+1)) $template >> $generated

build_dir=xetex_build_dir
mkdir -p $build_dir
xelatex -output-directory $build_dir $generated
if [[ ! $? ]]; then
	exit 1
fi
mv $build_dir/*.pdf uke.pdf

