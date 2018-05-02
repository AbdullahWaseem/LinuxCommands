#!/bin/bash
# SCRIPT INFORMATION:
#	This script compiles the latex project in linux with bibliography and nomenclature and output the result on a a4 pdf reader "evince".
# HOW TO USE?
#	Copy this file in the latex project folder.
#	Open the terminal in that folder.
#	and type return 	./Bash_Latex.sh
#	IT WILL REMOVE ALL THE LATEX FILES IF YOU DO NOT WANT THIS COMMENT-OUT LINE 18.
#	Then it will prompt for the name of the latex file. Write it WITHOUT .tex extension.
#	After some compilation, it will show the generated pdf in evince reader. Pdf reader can be changed on line 57 to a desired one.
#	The page options can be changed on lines 47 and 48.
# Author: 	 Abdullah Waseem
# Email:	 engineerabdullah@ymail.com
# Last Modified: 20 September, 2017


# Removing all the previous latex file from the current folder.
rm *.dvi *.ps *.aux *.log *.blg *.bbl *.toc *.nlo *.nls *.ilg 

# Clear the terminal screen.
clear
# Echo that it has been removed.
echo "All the previous latex file from the current folder has been removed."

# Enter the latex file name without extension.
echo "Enter the latex file name without extension  :"
# Reading the file name.
read filename

# Remove the pdf files only associated to the filename
rm $filename.pdf

# 2 times latex.
latex $filename.tex 
latex $filename.tex 

# 2 time bibtex.
bibtex $filename.aux 
bibtex $filename.aux 

# 2 time latex again.
latex $filename.tex 
latex $filename.tex 

# 2 time nomenclature (for making list of symbols).
makeindex $filename.nlo  -s  nomencl.ist  -o $filename.nls 
makeindex $filename.nlo  -s  nomencl.ist  -o $filename.nls 

# 2 times latex.
latex $filename.tex 
latex $filename.tex 

# 2 time ps
dvips -Ppdf -t a4 $filename.dvi 
dvips -Ppdf -t a4 $filename.dvi 

# 1 time pdf.
ps2pdf -dEmbedAllFonts=true $filename.ps 

# Clear the terminal screen
clear

# Open the created pdf with evince 
evince $filename.pdf &
