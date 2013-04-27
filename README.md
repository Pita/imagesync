# About Image sync

Image sync is a small shell script that allows you to backup your photographs in a very efficient way. It's made with the assumption that you have a very slow and unreliable internet connection.

All photos are getting resized before they get uploaded via rsync to a backup server. After the resized images are uploaded, it uploads the original full resolution images. This way you can upload low resolution pictures quickly and use the remaining bandwith to upload the originals. Using rsync allows you to stop and continue the process whenever you want.

## Folder structure

### raw
In this folder you should put all the original images without any modifications 

### edit
This folder is for files that you created while editing the original images. For example a photoshop file

### final
This folder is for photographs that you selected and edited and are ready for the world to see

### lq_final, lq_raw
These folders are auto populated by the sync script. They're filled with low resolution version of the final and raw photographs

The folders are getting synced using this priority: lq_final, lq_raw, final, raw, edit

## Usage

### Dependencies
    sudo apt-get install rsync imagemagick

### Settings
    cp CONFIG.sh.template CONFIG.sh
then edit the config file

### Sync
    ./sync.sh