#!/bin/sh

INDEX="$(pwd)/docs/index.tex"

cat ./docs/head.tex > $INDEX

cd ./conferences
CONFERENCES="$(ls -d */)"
for conference in $CONFERENCES; do
    cd "$conference"
    YEARS="$(ls -d */)"
    for year in $YEARS; do
        cd "$year"
        HEADER="\\\section*{$(basename $conference) $(basename $year)}"
        echo $HEADER
        convert -alpha remove logo.png alogo.png
        vtracer --filter_speckle 1 --input alogo.png --output logo.svg
        svg2tikz --figonly --indent --output=logo.tikz logo.svg
        #sed "1s;^;$HEADER\n;" logo.tikz > logo.tex
        printf "$HEADER\n" >> $INDEX
        cat ./logo.tikz >> $INDEX
        rm -v alogo.png logo.svg 
        cd ..
    done
    cd ..
done
cd ..

cat ./docs/tail.tex >> $INDEX
cd ./docs
htlatex index.tex
rm -v index.4ct index.4tc index.aux index.dvi index.idv \
        index.lg index.log index.tmp index.xref
cd ..
