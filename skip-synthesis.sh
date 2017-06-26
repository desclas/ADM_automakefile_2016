#!/bin/bash

have_name(){
    local i=0
    local k=0
    local len=${#nom}
    while [ $i -lt $len ] && [ "${nom:$i:1}" != " " ]
    do
	i=$(($i+1))
    done
    while [ $i -lt $len ] && [ "${nom:$i:1}" = " " ]
    do
	i=$(($i+1))
    done
    while [ $i -lt $len ] && [ "${nom:$i:1}" != " " ]
    do
	i=$(($i+1))
    done
    while [ $i -lt $len ] && [ "${nom:$i:1}" = " " ]
    do
	i=$(($i+1))
    done
    k=$(($i+0))
    while [ $k -lt $len ] && [ "${nom:$k:1}" != " " ]
    do
	k=$(($k+1))
    done
    local res=$(($k-$i))
    echo -n "${nom:$i:$res}"
    res=$((20-$res))
    i=0
    while [ $i -lt $res ]
    do
	echo -n " "
	i=$(($i+1))
    done
}

file_name(){
    local i=${#nom}
    while [ $i -gt 0 ] && [ "${nom:$i:1}" != " " ]
    do
	i=$(($i-1))
    done
    echo "${nom:$i}"
}

print_it(){
    have_name
    file_name
}

read nom
if [ -n "$nom" ]; then
    read nom
    while [ -n "$nom" ]
    do
	print_it
	read nom
    done
    exit 0
fi
exit 0
