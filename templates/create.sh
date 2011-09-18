#!/bin/sh

if [ -d templates ]; then
    cd templates
fi

PAGES="index previous about"

for page in $PAGES; do
    echo "Creating $page..."
    tpage $page.tt > ../generated/$page.html

    if [ "$?" -ne "0" ]; then
        echo "Failed"
        exit 1
    fi
done

exit 0;

