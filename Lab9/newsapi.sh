#!/bin/bash
touch ./output.json
#API key is stored in environment variable
apikey="$NEWSAPI_KEY"
#Getting the topic
read -p "Please enter the topic: " topic
#Creating request url
link="https://newsapi.org/v2/everything?q=${topic}&apiKey=${apikey}&sortBy=popularity"
#Writing response to temp file
curl -o output.json --url "$link"

#Checking status
respstat=$(jq '.status' output.json)

echo "Response status: ${respstat}"

if [[ ${respstat} == '"ok"' ]]; then

	#If status is ok
	num=$(jq '.articles | length' output.json)

	#Declaring how many articles to output
	read -p "There are ${num} articles. How many would you like to see? " k

	#Writing the articles
	for i in $(seq 0 $(( k-1 ))); do
		echo "Source: $(jq --argjson i "$i" '.articles[$i] | .source | .name' output.json), author: $(jq --argjson i "$i" '.articles[$i] | .author' output.json), title: $(jq --argjson i "$i" '.articles[$i] | .title' output.json)"
		echo "Description: $(jq --argjson i "$i" '.articles[$i] | .description' output.json)"
		echo "URL: $(jq --argjson i "$i" '.articles[$i] | .url' output.json)"
		echo ""
	done
fi

#Cleaning
rm output.json

#I've done this using jq library, which allows to create and operate json files easily
#But actually, I struggled a bit trying to do this