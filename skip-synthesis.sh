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
    echo -ne '\t'
}

file_name(){
    local i=${#nom}
    while [ $i -gt 0 ] && [ "${nom:$i:1}" != " " ]
    do
	i=$(($i-1))
    done
    echo "${nom:$i}"
}

check_file(){
    local i=${#nom}
    local len=${#1}
    while [ $i -gt 0 ] && [ "${nom:$i:1}" != " " ]
    do
	i=$(($i-1))
    done
    i=$(($i+1))
    if [ ${nom:$i:$len} = $1 ]; then
	return 0
    else
	return 1
    fi
}

print_it(){
    check_file $1
    if [ $? -eq 0 ]; then
	have_name
	file_name
    fi
}

if [ $# -eq 1 ]; then
    read nom
    if [ -n "$nom" ]; then
	read nom
	while [ -n "$nom" ]
	do
	    print_it $1
	    read nom
	done
	exit 0
    fi
fi
exit 0

