# easy-backup
A simple way to backup any files in linux while keeping everything tidy and ordered.


## Installation

To install the tool simply clone the repository and make the tool executable.

```` bash
#clone the repository
git clone https://github.com/alvaropek/easy-backup.git

#pull out the backup.sh script
mv easy-backup/backup.sh .

#remove the leftover folder
rm -rf easy-backup

#make the script executable
chmod +x backup.sh 
````



## Functionality

The command backup.sh allows users to quickly make and manage file backups in several ways:

Making a backup is as easy as running the program followed by the file to backup:

![image](https://github.com/user-attachments/assets/4928e0d3-1d3e-4cbb-99cb-ee3a982ea8b0)

The backup files will carry a date-time tail appended to their name.



### Backup visualization

There are several options to visualize the contents of your backups folder from anywhere in the system:

The most visual is the option -t (from tree):

![image](https://github.com/user-attachments/assets/1250ac2f-9ea0-42c5-af20-e76ebd528ded)

But the overall contents of the folder can also be listed with -l (from 'list'):

![image](https://github.com/user-attachments/assets/6d8ebc3c-ef66-4ee5-8fdc-1d9a04e2522f)

Also, the option -L can list the contents of a backup folder for a specific file:

![image](https://github.com/user-attachments/assets/727f70b9-5f4c-4f5b-a9f3-3efa77fa4b47)

Besides visualization, backup.sh can interect the backup folder in two main other ways:


### Restoring a backup in the current folder.

Any backup can be brought to the current working directory with options -b, -B, -c and -C.

Options -b and -c (from 'bring' and 'copy') will copy the **last** backup of a certain file. 

The difference is that -b will remove the date-and-time tail from the name of the file while -c will keep it.

![image](https://github.com/user-attachments/assets/33bde345-d98b-4cd1-8930-12590777939c)


Options -B and -C have the same funtcionality but a specific backup file instance needs to provided including its date-and-time tail (for when the last backup is not the target).

![image](https://github.com/user-attachments/assets/5a2b5060-e289-4e68-8005-37bad24442b4)


### Cleaning and deleting backup folders

Backups can easily build up, either in the form of backups of files that are no longer needed or unnecessary older backups of files in use.

To deal with this, backup.sh provides options -p, -P, -d and -D.

Options -p and -P (from 'purge') will eliminate all but the last backup, while options -d and -D will eliminate all backups.

The difference between the lowercase and uppercase version of these options is that -p and -d will act on specific backup folder provided by the user while -P and -D will act on all backup folders.

![image](https://github.com/user-attachments/assets/4b9bb78a-6c2c-42ef-9e49-f9a2c0c0e0fd)

As a failsafe options -P and -D will need to be paired with option -a (from 'all'). 

![image](https://github.com/user-attachments/assets/ea09b0b8-303a-4d29-a81b-c666735e22ca)




### Help Panel

[+] Standard Usage:
        If you want to make backup simply run backup.sh followed by the name of a file.
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
