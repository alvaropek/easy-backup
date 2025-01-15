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

backup_path="ADD_YOUR_PATH_HERE"

current_date_time=$(date +"%Y-%m-%d_%H:%M:%S")


# Initialize variables for options and the main argument

backup_mode=0

needs_all=false

# Functions

function check_too_many_options(){

        if [ $backup_mode -gt 1 ]; then
                echo -e "\n${redcol}Too many options provided. Trying to perform different actions at once is not supported.${endcol}"
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
        elif [ $chosen_option == "P" ]; then
                purge_all_backup
        elif [ $chosen_option == "d" ]; then
                delete_backup
        elif [ $chosen_option == "D" ]; then
                delete_all_backup
        elif [ $chosen_option == "h" ]; then
                help_panel
        fi

}


function list_backup(){

        #This function should work both for -l and -L

        # Check whether a file was provided
        if [ "$target" ]; then
                if [ -d "$backup_path/$target" ]; then 
                        echo
                        ls -1 "$backup_path/$target" 
                fi 

        else 
                backup_dirs="$(ls -1 "$backup_path")"
                echo
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
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                cp -i "$backup_path/$target/$last_file" .
                mv -i $last_file "$(echo "$last_file" | rev | cut -c 21- | rev)" 
                echo -e "\nBrought last backup file (${greencol}$last_file${endcol}) to current directory."
        else
                folder="$(echo "$target" | rev | cut -c 21- | rev)"
                cp -i "$backup_path/$folder/$target" .
                mv -i "$target" "$folder" 
                echo -e "\nBrought ${greencol}"$backup_path/$folder/$target"${endcol} to current directory."
        fi
}

function copy_backup(){

        if [ $last_only ]; then
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                cp -i "$backup_path/$target/$last_file" .
                echo -e "\nCopied last backup file (${greencol}$last_file${endcol}) to current directory."
        else
                folder="$(echo "$target" | rev | cut -c 21- | rev)"
                cp -i "$backup_path/$folder/$target" .
                echo -e "\nCopied ${greencol}"$backup_path/$folder/$target"${endcol} to current directory."
        fi
}

function purge_backup(){

        if [ -d "$backup_path/$target/" ]; then
                last_file="$(ls -1 "$backup_path/$target" | tail -n 1)"
                echo -e "\nKeeping last file: ${greencol}$last_file${endcol}"
                find "$backup_path/$target/" -type f ! -name "$last_file" -exec rm -f {} +
        else
                echo -e "\n${redcol}Folder $target does not exist!${endcol}"
        fi
}


function purge_all_backup(){

        if [ ! $extra_for_all ]; then
                echo -e "\n${redcol}This option requires confirmation from the -a (all) option.${endcol}"
                echo -e "\n${redcol}This option will purge all backup folders, leaving only the last backup for each file.${endcol}"
                echo -e "\n${redcol}If this is your intention, please add -a and try again.${endcol}"
                exit 0
        else
                all_folders="$(ls -1 "$backup_path")"
                echo -e "$all_folders" | while read line; do

                        if [ -d "$backup_path/$line/" ]; then
                                last_file="$(ls -1 "$backup_path/$line" | tail -n 1)"
                                echo -e "\nKeeping last file: ${greencol}$last_file${endcol}"
                                find "$backup_path/$line/" -type f ! -name "$last_file" -exec rm -f {} +

                        else
                                echo -e "\n${redcol}Folder $target does not exist!${endcol}"
                        fi
                done
        fi
}

function delete_all_backup(){

        if [ ! $extra_for_all ]; then
                echo -e "\n${redcol}This option requires confirmation from the -a (all) option.${endcol}"
                echo -e "\n${redcol}This option will delete all backup folders, leaving nothing behind.${endcol}"
                echo -e "\n${redcol}If this is your intention, please add -a and try again.${endcol}"
                exit 0
        else
                echo -e "${yellowcol}You will delete all your backups! You have 8 seconds to stop the script...${endcol}\n"
                sleep 8
                rm -rf "$backup_path"/* && echo "All backups removed successfully"

        fi
}

function delete_backup(){

        if [ -d "$backup_path/$target/" ]; then
                echo -e "${yellowcol}You will delete all $target backups! You have 5 seconds to stop the script...${endcol}\n"
                sleep 5
                rm -rf "$backup_path/$target" && echo "All backups for $target removed successfully"
        fi

}

function help_panel(){

echo -e "
Backup your files into a special backup folder. 

Your current backup folder path is: ${greencol}$backup_path${endcol}

[+] Standard Usage:
        If you want to make backup simply run $0 followed by the name of a file.
        This tool currently does not support multiple file handling.

[+] Advanced usage:
        If you want to interact with your backup folders in a more advanced way, the following options are available:

        -l) List number of backups and last date of backup per folder as a list.
        -L) List all backups from a specific file (Requires a file name as a parameter).
        -t) List all backups as a tree.
        -b) Copy last backup without the date and time extension (Requires file name as a parameter (without date time extension)).
        -B) Copy a specific backup without the date and time extension (Requires file name as a parameter (with date time extension)).
        -c) Copy last backup to current folder with the date and time extension (Requires file name as a parameter (without date time extension)).
        -C) Copy a specific backup with the date and time extension (Requires file name as a parameter (with date time extension)).
        -p) Purge all backup files of a certain folder except last file (Requires file name).
        -P) Purge all backup files of all folders except last backup file of each folder (Requires parameter -a (all)).
        -d) Delete all backup files of a certain folder (Requires file name).
        -D) Delete all backup files of all folders (Requires parameter -a (all)).
        -a) Perform action on all backup folders (required for Purge All (-P) and Delete All (-D). Otherwise ignored).
        -h) Display this help panel.
"

}

function make_backup(){

        # Check if file exists
        if [ -f $file_to_save ]; then

                # Check if directory for that file exists. If not, create one.
                if [ ! -d $backup_path/$file_to_save ]; then
                        mkdir $backup_path/$file_to_save
                fi

                # Copy the file with the current date and time appended to its name.
                cp $file_to_save $backup_path/$file_to_save/$file_to_save\_$current_date_time && echo -e "Created backup for $file_to_save as ${turquoisecol}$backup_path/$file_to_save/"$file_to_save"_"$current_date_time"${endcol}"

        else 
                # Report file not found.
                echo -e "\n${redcol}File${endcol} ${yellowcol}$file_to_save${endcol} ${redcol}not found.${endcol}"
        fi
}

# Checks to carry out before doing anything

# Check that a valid backup path has been stablished

# Parse options using getopts

while getopts "lL:tfb:B:c:C:p:Pd:Dah" arg; do
        case "$arg" in
                l) ((backup_mode++)); chosen_option="l";;
                L) target=$OPTARG; ((backup_mode++)); chosen_option="L";;
                t) ((backup_mode++)); chosen_option="t";;
                f) ((backup_mode++)); chosen_option="f";;
                b) target=$OPTARG; ((backup_mode++)); chosen_option="b"; last_only=true;;
                B) target=$OPTARG; ((backup_mode++)); chosen_option="B";;
                c) target=$OPTARG; ((backup_mode++)); chosen_option="c"; last_only=true;;
                C) target=$OPTARG; ((backup_mode++)); chosen_option="C";;
                p) target=$OPTARG; ((backup_mode++)); all_compatible=true; chosen_option="p";;
                P) target=$OPTARG; ((backup_mode++)); needs_all=true; chosen_option="P";;
                d) target=$OPTARG; ((backup_mode++)); needs_all=true; chosen_option="d";;
                D) target=$OPTARG; ((backup_mode++)); needs_all=true; chosen_option="D";;
                a) extra_for_all="true";;
                h) ((backup_mode++)); chosen_option="h";;
        esac
done


# Shift to remove parsed options before evaluating whether to make a backup

shift $((OPTIND - 1))

# Checks if there even is a file to backup before doing anything

if [ "$#" -eq 1 ] && [ $backup_mode -eq 0 ]; then

        file_to_save="$1"
        #echo "File $file_to_save registered"

elif [ "$#" -gt 1 ] && [ $backup_mode -eq 0 ]; then

    echo -e "\n${redcol}Error: Too many arguments.${endcol}"

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
        echo -e "\nIf you want to make a backup simply run: ./$0 [FILE] "
        exit 0

elif [ $backup_mode -eq 0 ]; then
        echo -e "\n${redcol}No file provided. Please provide a file to make a backup of.${endcol}"
        exit 0
fi



# Carry out options interpretation

check_too_many_options

if [ $backup_mode -eq 1 ]; then

        interpret_option

fi
