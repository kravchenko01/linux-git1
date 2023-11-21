#!/bin/bash
name=\"$1\"
#echo $name

i=1
#page=$(curl -s -X GET -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&page=$i&per_page=100")
#len=$(echo $page | jq 'length')
#kol=$(echo $page | jq "[.[] | select(.user.login==$name)] | length")
#echo $kol

pulls=0
pages='[]'
len=1
while [ $len -gt 0 ]
do    
    page=$(curl -s -X GET -H "$H2" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&page=$i&per_page=100") 
    pages=$(jq --slurp 'add' <(echo $pages) <(echo $page))
    len=$(echo $page | jq 'length')
    ((pulls+=$(echo $page | jq "[.[] | select(.user.login==$name)] | length") ))
    ((i++))
done

earliest_pr=$(echo $pages | jq "[.[] | select(.user.login==$name)] | sort_by(.created_at) | .[0]")
#earliest_pr=$(echo $sorted | jq ".[0]")
earliest=$(echo $earliest_pr | jq ".number")
merged=$(echo $earliest_pr | jq ".merged_at")

echo "PULLS" $pulls 
echo "EARLIEST" $earliest
if [[ $merged == "null" ]]; then
    echo "MERGED 0"
else
    echo "MERGED 1"
fi
