#!/bin/bash
# This script writes movies in "gif" and "avi" format from a sequence of images. First, it reads the first image in the sequence given by <filename.extension> and checks whether the width and the height of the first image are even or not, AVI writer requires even width and height. Then it changes the width and height to even if its not the case. Finally, it writes the movie files and REMOVES all the image files.
# 				Note: ImageMagick, ffmpeg, and libav-tools SHOULD BE INSTALLED.
# Author: 	 Abdullah Waseem
# Email:	 engineerabdullah@ymail.com
# Created:	 11 September, 2017
# Last Modified: 12 September, 2017

# Extracting the width and height of the first image
width="$(convert t_001.bmp -print %w /dev/null)"
height="$(convert t_001.bmp -print %h /dev/null)"

# Making width and height even.
if [ $((width%2)) -ne 0 ];
then
	width=$((width+1));
	printf "The width is odd, making it even. \n"
	mogrify -resize $width! *.bmp
fi
if [ $((height%2)) -ne 0 ];
then
	height=$((height+1));
	printf "The height is odd, making it even. \n"
	mogrify -resize x$height! *.bmp
fi

# Writing the GIF movie
printf "Making .GIF movie. \n"
convert -delay 0.001 -loop 0 *.bmp Movie.gif

# Writing the AVI movie
printf "Making .AVI movie \n"
ffmpeg -framerate 5 -i t_%03d.bmp -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p Movie.avi

rm *.bmp
