#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    protocol=$(echo "$line"| cut -d':' -f 1)
    if [ "$protocol" = https ]; then
        url=$(echo "$line"| cut -d',' -f 1)
        if [ -n "$url" ]; then
            origin_data=$(curl -s -L -b ./cookies.txt "$url")

	    json="{"
	    for field in Architecture Channel Date DistroRelease DuplicateSignature ErrorMessage ProblemType Snap SystemIdentifier SAS; do
		value=$(echo $origin_data | perl -ne '/<div id="field-\d*?" class="'$field'">\s*(.*?)\s*<\/div>/ && print "$1"')
		json="${json}\"${field}\":\"${value}\""
		if [ "$field" != SAS ]; then
		    json="${json},"
		fi
	    done
	    json="${json}}"
	    mongo report --eval "db.errors.insert(${json})"
        fi
    fi
done < "$1"
