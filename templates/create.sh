#!/bin/sh

if [ -d templates ]; then
    cd templates
fi

echo "Attempting to create index.html..."
tpage index.tt > ../generated/index.html
if [ "$?" -ne "0" ]; then
	echo "Unable to create index.html"
	exit 1
fi

echo "Attempting to create previous.html..."
tpage previous.tt > ../generated/previous.html
if [ "$?" -ne "0" ]; then
        echo "Unable to create previous.html"
        exit 1 
fi 

echo "Attempting to create previous.html..."
tpage about.tt > ../generated/about.html
if [ "$?" -ne "0" ]; then
        echo "Unable to create about.html"
        exit 1 
fi 

exit 0;

