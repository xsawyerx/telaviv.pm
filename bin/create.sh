#!/bin/sh

mkdir generated

if [ -d templates ]; then
    cd templates
fi

../bin/render_events.pl events.haml > previous.tt

PAGES="index previous about photos"

for page in $PAGES; do
    echo "Creating $page..."
    tpage --define page=$page $page.tt > ../generated/$page.html

    if [ "$?" -ne "0" ]; then
        echo "Failed"
        exit 1
    fi
done

cd ..

cp -rv images/ style.css generated/

exit 0;

