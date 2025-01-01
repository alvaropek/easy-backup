#!/bin/bash

backup_path="WRITE YOUR PATH HERE!"

current_date_time=$(date +"%Y-%m-%d_%H:%M:%S")

echo $current_date_time\n

file_to_save=$1

function make_backup(){

if [ -f $file_to_save ]; then

        if [ ! -d $backup_path/$file_to_save ]; then
                mkdir $backup_path/$file_to_save
        fi
        cp $file_to_save $backup_path/$file_to_save/$file_to_save\_$current_date_time && echo -e "Created backup for $file_to_save as $backup_path/$file_to_save/$file_to_save\_$current_date_time"}

else 
        echo -e "\nFile $file_to_save not found."
fi

}
if [ ! -d $backup_path ]; then
echo -e '
The backup path specified in backup.sh is either empty or does not exist.

Please edit the variable at the beginning of the backup.sh script to select a correct path for backups.

Make sure to write the path location WITHOUT a slash (/) at the end.

Example: backup_path="/home/user/backups"'

elif [ $file_to_save ]; then
        make_backup
else
        echo -e "\nNo file provided. Please provide a file to make a backup of."
fi
