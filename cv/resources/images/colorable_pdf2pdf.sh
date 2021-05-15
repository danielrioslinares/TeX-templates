#!/bin/bash

###############################################################################
echo "This is 'colorable_pdf2pdf this will inspect all your subfolder destroying all pdfs and creating a non compressed version of it, careful"
while true; do
    read -p "Continue? (y/n) " ans
    case $ans in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "(y/n) please -.-\"";;
    esac
done
###############################################################################

# First of all, convert all old pdf to ps
find . -type f -iname '*.pdf' -print0 |
   while IFS= read -r -d '' file
      do pdf2ps "${file}" "${file%.*}.ps"
      echo "${file} has been converted to ps"
done

# The convert back to pdf with no compression
find . -type f -iname '*.ps' -print0 |
   while IFS= read -r -d '' file
      do ps2pdf -dEPSCrop -dCompressPages=false "${file}" "${file%.*}.pdf"
      echo "${file} has been converted to pdf back again"
      rm "${file}"
done
