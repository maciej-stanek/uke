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

CHORDS_DIR=chords
mkdir -p $CHORDS_DIR

CHORD_NAME=$1
CHORD=(${2:0:1} ${2:1:1} ${2:2:1} ${2:3:1})
echo "Got chord name \"$CHORD_NAME\" and strings (${CHORD[@]})"

STRING_MAX=0
for i in ${CHORD[@]}; do
	if [[ $i > $STRING_MAX ]]; then
		STRING_MAX=$i
	fi
done
echo "Max bar distance is $STRING_MAX"

IM_CMD="convert"
IM_WIDTH=400
IM_SIDEMARGIN=10
IM_POINTSIZE=140
IM_BARSPACING=90
IM_BAROVERFLOW=30
IM_NOTERADIUS=30
IM_TOPMARGIN=$((IM_POINTSIZE+15))
IM_BOTTOMMARGIN=10
IM_BARTOPTHICKNESS=16
IM_BARTHICKNESS=10
IM_STRINGTHICKNESS=6
IM_BARCOUNT=$((STRING_MAX>4?STRING_MAX:4))
IM_HEIGHT=$((IM_TOPMARGIN+IM_BARCOUNT*IM_BARSPACING+IM_BOTTOMMARGIN))
echo "IM_HEIGHT=$IM_HEIGHT"
IM_STRINGS_D=($((IM_WIDTH*1/8)) $((IM_WIDTH*3/8)) $((IM_WIDTH*5/8)) $((IM_WIDTH*7/8)))

IM_CMD+=" -size ${IM_WIDTH}x${IM_HEIGHT} xc:white"
IM_CMD+=" -fill black"
IM_CMD+=" -gravity north"
IM_CMD+=" -pointsize $IM_POINTSIZE"
IM_CMD+=" -font Ubuntu-Condensed"
IM_CMD+=" -draw 'text 0,0 $1'"
IM_CMD+=" -stroke black"
IM_CMD+=" -strokewidth $IM_BARTHICKNESS"
for (( i=1; i<$IM_BARCOUNT; i++ )); do
	topd=$((IM_TOPMARGIN+IM_BARSPACING*i))	
	IM_CMD+=" -draw 'line $((IM_STRINGS_D[0]-IM_BAROVERFLOW)),$topd $((IM_STRINGS_D[3]+IM_BAROVERFLOW)),$topd'"
done
IM_CMD+=" -strokewidth $IM_STRINGTHICKNESS"
for i in 0 1 2 3; do
	IM_CMD+=" -draw 'line ${IM_STRINGS_D[$i]},$IM_TOPMARGIN ${IM_STRINGS_D[$i]},$((IM_HEIGHT-IM_BOTTOMMARGIN))'"
	if [[ ${CHORD[$i]} > 0 ]]; then
		topd=$(((CHORD[$i]-1)*IM_BARSPACING+IM_BARSPACING/2+IM_TOPMARGIN))
		IM_CMD+=" -draw 'circle ${IM_STRINGS_D[$i]},$topd,$((IM_STRINGS_D[$i]+IM_NOTERADIUS)),$topd'"
	fi
done
IM_CMD+=" -strokewidth $IM_BARTOPTHICKNESS"
IM_CMD+=" -draw 'line $IM_SIDEMARGIN,$IM_TOPMARGIN $((IM_WIDTH-IM_SIDEMARGIN)),$IM_TOPMARGIN'"
IM_CMD+=" $CHORDS_DIR/$1.png"

echo $IM_CMD
eval $IM_CMD
