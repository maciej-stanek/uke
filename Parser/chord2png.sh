#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Error, wrong number of arguments. Usage:"
	echo "$0 <chord_name> <chord_strings:[0-9]{4}>"
	exit 1
fi
if [[ ! $2 =~ [0-9]{4} ]]; then
	echo "Error, strings description does not comply to the syntax [0-9]{4}"
	exit 1
fi

CHORD_NAME=$1
CHORD=(${2:0:1} ${2:1:1} ${2:2:1} ${2:3:1})
echo "Got chord name \"$CHORD_NAME\" and strings (${CHORD[@]})"

STRING_MAX=0
for i in ${CHORD[@]}; do
	if [[ $i > $STRING_MAX ]]; then
		STRING_MAX=$i
	fi
done
echo "Max string value is $STRING_MAX"

IM_CMD="convert"
IM_POINTSIZE=70
IM_WIDTH=200
IM_HEIGHT=300
IM_TOPMARGIN=$((IM_POINTSIZE+15))
IM_BOTTOMEND=$((IM_HEIGHT-10))
IM_STRINGS_D=($((IM_WIDTH*1/8)) $((IM_WIDTH*3/8)) $((IM_WIDTH*5/8)) $((IM_WIDTH*7/8)))
IM_STRINGS_OPTS=
for d in ${IM_STRINGS_D[@]}; do
	IM_STRINGS_OPTS+=" -draw 'stroke-linecap round line $d,$IM_TOPMARGIN $d,$IM_BOTTOMEND'"
done

IM_CMD+=" -size ${IM_WIDTH}x${IM_HEIGHT} xc:white"
IM_CMD+=" -fill black"
IM_CMD+=" -gravity north"
IM_CMD+=" -pointsize $IM_POINTSIZE"
IM_CMD+=" -font DejaVu-Serif-Condensed-Italic"
IM_CMD+=" -draw 'text 0,0 $1'"
IM_CMD+=" -strokewidth 2"
IM_CMD+=" -stroke black"
IM_CMD+=$IM_STRINGS_OPTS
IM_CMD+=" -strokewidth 8"
IM_CMD+=" -draw 'stroke-linecap round line 10,$IM_TOPMARGIN 190,$IM_TOPMARGIN'"
IM_CMD+=" $1.png"

echo $IM_CMD
eval $IM_CMD
