#!/bin/bash
IFS=''
firstchar=0
pin=22
minidisc="/home/pi/minidisc.json"
commander="/home/pi/commander.json"

echo ""
echo "====+EASY TITLE+========================"
echo " ' / ? ( ) . ! - and spaces are allowed"
echo " # to ENTER title"
echo " { } to CHANGE tracks"
echo "  | to toggle EDIT mode"
echo " < > to MOVE cursor in EDIT mode"
echo "  ~ to CONFIRM name and MOVE to next"
echo "  ^ to CLEAR char"
echo " Ctrl-C to quit"
echo "========================================"
echo ""
if [[ "$1" == "edit" ]]; then
    sleep 0;
else
    piir play -r 2 --gpio $pin --file $minidisc NEXT
    piir play -r 2 --gpio $pin --file $commander WNAME
    sleep 0.2
    piir play -r 2 --gpio $pin --file $commander +
    sleep 0.2
fi
# read a single character
while read -r -n1 key
do
if [[ "$key" =~ [a-z] ]]; then
    piir play -r 2 --gpio $pin --file $commander $key
elif [[ "$key" =~ [A-Z] ]]; then
    if [[ "$firstchar" == 1 ]]; then
        piir play -r 2 --gpio $pin --file $commander $key
        piir play -r 2 --gpio $pin --file $commander +
        firstchar=0
        sleep 0.6
    else
        piir play -r 2 --gpio $pin --file $commander +
        sleep 0.6
        piir play -r 2 --gpio $pin --file $commander $key
        piir play -r 2 --gpio $pin --file $commander +
        sleep 0.6
    fi
elif [[ "$key" =~ [0-9] ]]; then
    piir play -r 2 --gpio $pin --file $commander 123
    sleep 0.6
    piir play -r 2 --gpio $pin --file $commander $key
    piir play -r 2 --gpio $pin --file $commander 123
    sleep 0.6
elif [[ "$key" =~ " " ]]; then
    piir play -r 2 --gpio $pin --file $commander SPACE
elif [[ "$key" == $'\x7f' ]]; then
    piir play -r 2 --gpio $pin --file $commander "<"
    piir play -r 2 --gpio $pin --file $commander "^"
elif [[ "$key" = "|" ]]; then
    piir play -r 2 --gpio $pin --file $commander WNAME
elif [[ "$key" = "}" ]]; then
    piir play -r 2 --gpio $pin --file $minidisc NEXT
elif [[ "$key" = "{" ]]; then
    piir play -r 2 --gpio $pin --file $minidisc PREV
elif [[ "$key" = "~" ]]; then
    piir play -r 2 --gpio $pin --file $commander WNAME
    piir play -r 2 --gpio $pin --file $minidisc NEXT
    piir play -r 2 --gpio $pin --file $commander WNAME
    firstchar=1
    sleep 0.3
elif [[ "$key" = "" ]]; then
    sleep 0
else
    piir play -r 2 --gpio $pin --file $commander $key
    if [[ "$key" == "+" ]]; then sleep 0.6
    fi
fi

done
