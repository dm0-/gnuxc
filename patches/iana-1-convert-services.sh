#!/bin/bash

echo -n '# Automatically generated from IANA services registry on '
date -u '+%Y-%m-%d.'

cat - <(echo -n END,65536,,,) |
tr '\n\r' ' \n' |
sed 's/^ *//;s/,,/,-,/' |
LC_ALL=C sort -t, -k2n,2 -k3,3 |
while IFS=, read -rs name port transport description assignee
do
        [ "$name" == END ] && echo -e "${alt:-\t}# $olddesc" && continue

        name=${name##*\(} name=${name%%\)*} name=${name//\ /-}
        [ -n "$name" ] || continue

        [[ $port =~ ^[0-9]+$ ]] && [ "$transport" != - ] || continue
        (( ${#port} + ${#transport} < 7 )) && transport+='\t'

        [ "$oldport" == "$port/$transport" ] && alt+="${alt:+ }$name" && continue
        (( ${#name} <  8 )) && name+='\t'
        (( ${#alt}  >= 8 )) && alt+=' '
        (( ${#alt}  <  8 )) && alt+='\t'
        echo -en "${olddesc:+$alt# $olddesc\n}$name\t$port/$transport\t"

        alt=
        olddesc=$(echo -n $description | sed 's/[ \t]\+/ /g;s/^ *" *//;s/ *" *$//;s/""/"/g')
        oldport="$port/$transport"
done
