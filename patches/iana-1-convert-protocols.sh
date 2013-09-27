#!/bin/bash

echo -n '# Automatically generated from IANA protocols registry on '
date -u '+%Y-%m-%d.'

tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
while IFS=, read -rs decimal keyword protocol reference
do
        [[ $decimal =~ ^[0-9]+$ ]] || continue

        keyword=${keyword// /-}
        [[ $keyword =~ ^-|Reserved$ ]] && continue
        (( ${#keyword} < 8 )) && keyword+='\t'

        protocol=$(echo -n $protocol | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')

        echo -e "${keyword,,}\t$decimal\t$keyword\t# $protocol"
done
