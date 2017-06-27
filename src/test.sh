#!/bin/bash

check_pjd(){
    local i=0
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:12}" = "PROJECT_DIR;" ]; then
	    test -e "${tab[$i]:0:12}" -a -d "${tab[$i]:0:12}"
	    if [ $? -eq 1 ]; then
		exit 84
	    else
		return 0
	    fi
	fi
	i=$(($i+1))
    done
    return 1
}

check_dotc(){
    local i=0
    local k=0
    while [ $i -lt ${#tab} ]; do
	k=0
	while [ $k -lt ${#tab[$i]} ] && [ "${tab[$i]:$k:1}" != ";" ]; do
	    if [ "${tab[$i]:$k:2}" = ".c" ]; then
		return 0
	    fi
	    k=$(($k+1))
	done
	i=$(($i+1))
    done
    return 1
}

all_c(){
    local i=0
    local k=0
    local len=0
    while [ $i -lt ${#tab} ]; do
	k=0
	while [ $k -lt ${#tab[$i]} ] && [ "${tab[$i]:$k:1}" != ";" ]; do
	    if [ "${tab[$i]:$k:2}" = ".c" ]; then
		break
	    fi
	    k=$(($k+1))
	done
	if [ "${tab[$i]:$k:2}" = ".c" ]; then
	    break
	fi
	i=$(($i+1))
    done
    len=$(($k+2))
    echo -n "${tab[$i]:0:$len}" >> "$makeit"
    i=$(($i+1))
    while [ $i -lt ${#tab} ]; do
	k=0
	while [ $k -lt ${#tab[$i]} ] && [ "${tab[$i]:$k:1}" != ";" ]; do
	    if [ "${tab[$i]:$k:2}" = ".c" ]; then
		len=$(($k+2))
		echo -e "\t\\" >> "$makeit"
		echo -ne "\t\t${tab[$i]:0:$len}" >> "$makeit"
		break
	    fi
	    k=$(($k+1))
	done
	i=$(($i+1))
    done
}

cc_flag(){
    local i=0
    echo -ne "CC\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:3}" = "CC;" ]; then
	    echo -ne "\t${tab[$i]:3}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
}

if_include(){
    local i=0
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:12}" = "HEADERS_DIR;" ]; then
	    echo -n " -I${tab[$i]:12}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
}

cflag(){
    local i=0
    echo -ne "CFLAGS\t+=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:7}" = "CFLAGS;" ]; then
	    echo -ne "\t${tab[$i]:7}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    if_include
    echo >> "$makeit"
    echo >> "$makeit"
}

ld_flag(){
    local i=0
    echo -ne "LDFLAGS\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:8}" = "LDFLAGS;" ]; then
	    echo -ne "\t${tab[$i]:8}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
}

p_exec(){
    local i=0
    echo -ne "EXEC\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:5}" = "EXEC;" ]; then
	    echo -ne "\t${tab[$i]:5}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
}

p_bckdir(){
    local i=0
    echo -ne "BCK_DIR\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:8}" = "BCK_DIR;" ]; then
	    echo -ne "\t${tab[$i]:8}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
}

p_unzipflags(){
    local i=0
    echo -ne "UNZIPFLAGS\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:11}" = "UNZIPFLAGS;" ]; then
	    echo -ne "\t${tab[$i]:11}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
    p_bckdir
}

p_unzip(){
    local i=0
    echo -ne "UNZIP\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:6}" = "UNZIP;" ]; then
	    echo -ne "\t${tab[$i]:6}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
    p_unzipflags
}

p_zipflag(){
    local i=0
    echo -ne "ZIPFLAGS\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:9}" = "ZIPFLAGS;" ]; then
	    echo -ne "\t${tab[$i]:9}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
    p_unzip
}

p_zip_and_unzip(){
    local i=0
    echo -ne "ZIP\t=" >> "$makeit"
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:4}" = "ZIP;" ]; then
	    echo -ne "\t${tab[$i]:4}" >> "$makeit"
	    break
	fi
	i=$(($i+1))
    done
    echo >> "$makeit"
    echo >> "$makeit"
    p_zipflag
}

p_end(){
    echo ".PHONY: all clean fclean re revert archive delete" >> "$makeit"
    echo >> "$makeit"
    echo "all: \$(EXEC)" >> "$makeit"
    echo >> "$makeit"
    echo "\$(EXEC): \$(OBJ)" >> "$makeit"
    echo -e "\t\$(CC) -o \$@ \$^ \$(LDFLAGS)" >> "$makeit"
    echo >> "$makeit"
    echo "clean:" >> "$makeit"
    echo -e "\trm -f \$(OBJ)" >> "$makeit"
    echo >> "$makeit"
    echo "fclean: clean" >> "$makeit"
    echo -e "\trm -f \$(EXEC)" >> "$makeit"
    echo >> "$makeit"
    echo "re: fclean all" >> "$makeit"
    echo >> "$makeit"
    echo "archive:" >> "$makeit"
    echo -e "\t\$(ZIP) \$(ZIPFLAGS) \$(BCK_DIR) \$(SRC)" >> "$makeit"
    echo >> "$makeit"
    echo "revert:" >> "$makeit"
    echo -e "\t\$(UNZIP) \$(UNZIPFLAGS) \$(BCK_DIR)" >> "$makeit"
    echo >> "$makeit"
    echo "delete:" >> "$makeit"
    echo -e "\trm -f \$(BCK_DIR)" >> "$makeit"
}

get_make(){
    local i=0
    declare -a tmp=()
    while [ $i -lt ${#tab} ]; do
	if [ "${tab[$i]:0:12}" = "PROJECT_DIR;" ]; then
	    tmp[0]="${tab[$i]:12}"
	    break
	fi
	i=$(($i+1))
    done
    if [ ${#tab[$i]} -eq 12 ]; then
	makeit="Makefile"
    else
	tmp[1]="Makefile"
	makeit=$(IFS="/"; echo "${tmp[*]}")
    fi
}

main_fnt(){
    echo -ne "SRC\t=\t" >> "$makeit"
    all_c
    echo >> "$makeit"
    echo >> "$makeit"
    echo -ne "OBJ\t=\t\$(SRC:.c=.o)" >> "$makeit"
    echo >> "$makeit"
    echo >> "$makeit"
    cc_flag
    cflag
    ld_flag
    p_exec
    p_zip_and_unzip
    p_end
}

if [ $# -ne 1 ]; then
    exit 84
fi
test -e "$1" -a -f "$1"
if [ $? -eq 1 ]; then
    exit 84
fi
declare -a tab=()
while read line ; do
    tab=( "${tab[@]}" "$line" )
done < $1
tab=( "${tab[@]}" "$line" )
check_pjd
if [ $? -ne 0 ]; then
    exit 84
fi
check_dotc
if [ $? -ne 0 ]; then
    exit 84
fi
get_make
if [ -e "$makeit" ]; then
    rm "$makeit"
fi
touch "$makeit"
main_fnt
exit 0
