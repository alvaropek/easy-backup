#!/bin/bash

#Colours
greencol="\e[0;32m\033[1m"
endcol="\033[0m\e[0m"
redcol="\e[0;31m\033[1m"
bluecol="\e[0;34m\033[1m"
yellowcol="\e[0;33m\033[1m"
purplecol="\e[0;35m\033[1m"
turquoisecol="\e[0;36m\033[1m"
graycol="\e[0;37m\033[1m"


# Set up behaviour exiting the function via Ctrl+C 
function ctrl_c(){
        echo -e "\n\n${redcol}[!] Exiting...$endcol\n"
        exit 1
}

trap ctrl_c INT

# Global variables

backup_path="/home/alvaropek/backups"

current_date_time=$(date +"%Y-%m-%d_%H:%M:%S")

echo $current_date_time\n

#file_to_save=$1

# Initialize variables for options and the main argument

flag_a=false

flag_f=false

flag_B=false



# Functions

function list_backups(){

        #This function should work both for -l and -L

        # Check whether a file was provided
        if [ "$target" ]; then
                if [ -d "$backup_path/$target" ]; then 
                        ls -1 "$backup_path/$target" 
                fi 
        else 
                backup_dirs="$(ls -1 "$backup_path")"
                echo -e "$backup_dirs" | while read line; do
                echo -e "$line \t\t $(ls -1 "$backup_path/$line" | wc -l) backups \t\t Last on "$(ls -1 "$backup_path/$line" | tail -n 1 | rev | cut -f 1-2 -d"_" | rev | sed 's/_/ at /')" "

                done


        fi
}

function go_to_backup_path() {

        bash
        cd "$backup_path"
        echo "$backup_path"
}


function make_backup(){

        # Check if file exists
        if [ -f $file_to_save ]; then

                # Check if directory for that file exists. If not, create one.
                if [ ! -d $backup_path/$file_to_save ]; then
                        mkdir $backup_path/$file_to_save
                fi

                # Copy the file with the current date and time appended to its name.
                cp $file_to_save $backup_path/$file_to_save/$file_to_save\_$current_date_time && echo -e "Created backup for $file_to_save as $backup_path/$file_to_save/$file_to_save\_$current_date_time"}

        else 
                # Report file not found.
                echo -e "\n${redcol}File${endcol} ${yellowcol}$file_to_save${endcol} ${redcol}not found.${endcol}"
        fi
}

# Checks to carry out before doing anything

# Check that a valid backup path has been stablished

# Parse options using getopts

while getopts "lL:tgb:B:c:C:p:d:ah" arg; do
        case "$arg" in
                l) echo 'List number of backups and last date of backup per folder as a list'; list_backups;;
                L) target=$OPTARG; echo 'List all backups from a certain folder'; list_backups;;
                t) echo 'List all backups as a tree';;
                g) echo 'Go to backup path'; go_to_backup_path;;
                b) target=$OPTARG; echo '(from "bring") Bring last backup without date and time.';;
                B) target=$OPTARG; echo '(from "Bring") Bring a specific backup (must provide full name of backup) without date and time.';;
                c) target=$OPTARG; echo '(from "copy") Bring last backup as is, with date and time.';;
                C) target=$OPTARG; echo '(from "copy") Bring a specififc  backup (must provide full name of backup) as is, with date and time.';;
                p) target=$OPTARG; echo 'Purge all backups of a certain folder except last one. Interacts with param -a (all)';;
                d) target=$OPTARG; echo 'Delete all backups of a certain folder.';;
                a) echo 'Perfom action on all folders and files of backup.';;
                h) echo 'Show help menu';;
        esac
done


# Shift to remove parsed options before evaluating whether to make a backup

shift $((OPTIND - 1))

# Checks to carry out before doing anything

if [ "$#" -eq 1 ]; then
        file_to_save="$1"
        echo "file $file_to_save registered"
else
    echo #"Error: Missing or too many arguments." >&2
fi



# Check that a valid backup path has been stablished

if [ ! -d $backup_path ]; then
        echo -e '
The backup path specified in backup.sh is either empty or does not exist.

Please edit the variable at the beginning of the backup.sh script to select a correct path for backups.

Make sure to write the path location WITHOUT a slash (/) at the end.

Example: backup_path="/home/user/backups"'

# Check that a file was indeed provided

elif [ $file_to_save ]; then
        make_backup
else
        echo # -e "\n${redcol}No file provided. Please provide a file to make a backup of.${endcol}"
fi

