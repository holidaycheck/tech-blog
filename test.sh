#!/usr/bin/env bash

function checkThumbnails () {
    echo -n "Checking if thumbnails for all categories are available .. "
    
    categories=$(grep  -h "^categories:" _posts/*.md | sed -e "s/categories: //" | sort | uniq)
    for c in $categories; do
        if ! test -f ./img/"$c"-thumbnail.jpg ; then
            echo "There is no thumbnail for the category \"$c\""
            exit 1
        fi
    done | sort | uniq
    echo "OK"
}

checkThumbnails
