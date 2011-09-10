#!/bin/sh

echo "Attempting to create index.html..."
tpage templates/index.tt > index.html
if [ "$?" -ne "0" ]; then
	echo "Unable to create index.html"
	exit 1
fi

echo "Attempting to create previous.html..."
tpage templates/previous.tt > previous.html
if [ "$?" -ne "0" ]; then
        echo "Unable to create previous.html"
        exit 1 
fi 

echo "Attempting to create previous.html..."
tpage templates/about.tt > about.html
if [ "$?" -ne "0" ]; then
        echo "Unable to create about.html"
        exit 1 
fi 

exit 0;

