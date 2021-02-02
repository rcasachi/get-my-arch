#!/bin/bash

# codecs and plugins
pacman -Syu 
sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins 
sudo pacman -S firefox aria2 wget git 
sudo pacman -S p7zip p7zip-plugins unrar tar rsync

