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

backup_mode=0

all_compatible=false

# Functions

function check_too_many_options(){

        if [ $backup_mode -gt 1 ]; then
                echo -e "\n${redcol}Too many options provided. Trying to perform different actions at once is not supported${endcol}"
                exit 0
        fi
}

function check_extra_for_all(){

        if [ ! $all_compatible ]; then
                echo -e "\n${redcol}This option is not compatible with flag -a (apply to all backup folders)."
                exit 0
        fi
}

function interpret_option(){

        echo -e "$backup_mode is backup_mode"
        if [ $chosen_option == "l" ] || [ $chosen_option == "L" ]; then
                list_backup
        elif [ $chosen_option == "t" ]; then
                tree_backup
        elif [ $chosen_option == "f" ]; then
                show_path
        elif [ $chosen_option == "b" ]; then
                bring_backup
        elif [ $chosen_option == "B" ]; then
                bring_backup
        elif [ $chosen_option == "c" ]; then
                copy_backup
        elif [ $chosen_option == "C" ]; then
                copy_backup
        elif [ $chosen_option == "p" ]; then
                purge_backup
        elif [ $chosen_option == "d" ]; then
                delete_backup
        fi

}


function list_backup(){

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

function tree_backup(){

        echo
        tree $backup_path
}

function show_path(){

        echo
        echo -e "Backup path:  ${turquoisecol}$backup_path${endcol}"
}

function bring_backup(){

        if [ $last_only ]; then
                echo 'you pressed b'
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                cp -i "$backup_path/$target/$last_file" .
                mv -i $last_file "$(echo "$last_file" | rev | cut -c 21- | rev)" 
        else
                echo 'you pressed B'
                folder="$(echo "$target" | rev | cut -c 21- | rev)"
                cp -i "$backup_path/$folder/$target" .
                mv -i "$target" "$folder" 
        fi
}

function copy_backup(){

        if [ $last_only ]; then
                echo 'you pressed c'
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                cp -i "$backup_path/$target/$last_file" .
        else
                echo 'you pressed C'
                folder="$(echo "$target" | rev | cut -c 21- | rev)"
                cp -i "$backup_path/$folder/$target" .
        fi
}

function purge_backup(){

        if [ -d "$backup_path/$target/" ]; then
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                echo "$last_file"
                find "$backup_path/$target/" -type f ! -name "$last_file" -exec rm -f {} +
        else
                echo -e "\n${redcol}No such folder mate!${endcol}"
        fi
}

function delete_backup(){

        if [ -d "$backup_path/$target/" ]; then
                echo "You will delete $target! You have 6 seconds to stop the script...\n"
                sleep 6
                rm -rf "$backup_path/$target" && echo "All backups for $target removed successfully"

        fi

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

while getopts "lL:tfb:B:c:C:p:d:ah" arg; do
        case "$arg" in
                l) echo 'List number of backups and last date of backup per folder as a list'; ((backup_mode++)); chosen_option="l";;
                L) target=$OPTARG; echo 'List all backups from a certain folder'; ((backup_mode++)); chosen_option="L";;
                t) echo 'List all backups as a tree'; ((backup_mode++)); chosen_option="t";;
                f) echo 'List path'; ((backup_mode++)); chosen_option="f";;
                b) target=$OPTARG; echo '(from "bring") Bring last backup without date and time.'; ((backup_mode++)); chosen_option="b"; last_only=true;;
                B) target=$OPTARG; echo '(from "Bring") Bring a specific backup (must provide full name of backup) without date and time.'; ((backup_mode++)); chosen_option="B";;
                c) target=$OPTARG; echo '(from "copy") Bring last backup as is, with date and time.'; ((backup_mode++)); chosen_option="c"; last_only=true;;
                C) target=$OPTARG; echo '(from "copy") Bring a specififc  backup (must provide full name of backup) as is, with date and time.'; ((backup_mode++)); chosen_option="C";;
                p) target=$OPTARG; echo 'Purge all backups of a certain folder except last one. Interacts with param -a (all)'; ((backup_mode++)); all_compatible=true; chosen_option="p";;
                d) target=$OPTARG; echo 'Delete all backups of a certain folder. Interacts with param -a (all)'; ((backup_mode++)); all_compatible=true; chosen_option="d";;
                a) echo 'Perform action on all folders and files of backup.'; extra_for_all="a";;
                h) echo 'Show help menu'; ((backup_mode++)); chosen_option="h";;
        esac
done


check_too_many_options

if [ $backup_mode -eq 1 ]; then

        interpret_option

fi

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

        exit 0
fi

# Check that a file was indeed provided and you are in backup mode

if [ $file_to_save ] && [ $backup_mode -eq 0 ]; then
        make_backup

elif [ $file_to_save ] && [ $backup_mode -eq 1 ]; then
        echo -e "\n${redcol}Using other option, do not add a file outside parameter.${endocol}"
        echo -e "\nIf you want to make a backup simply run: ./backup.sh [FILE] "

elif [ $backup_mode -eq 0 ]; then
        echo -e "\n${redcol}No file provided. Please provide a file to make a backup of.${endcol}"

fi

