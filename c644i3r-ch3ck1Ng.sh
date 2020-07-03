#!/bin/bash
echo "Content-type: text/html";
echo "";
#Set Header for CGI
if [ "$REQUEST_METHOD" = "POST" ]; then # check request type
    if [ "$CONTENT_LENGTH" -gt 0 ]; then # check if request has some data
    	#Continue executing the code
    	echo -e "" # just to continue execution to rest of code
	else
		#display error and exit
		echo "No Data found in Request";
		exit 0;
    fi
else
	#display error and exit
	echo "Only POST Request is supported";
	exit 0;
fi
carrier=$POST_DATA; # data of request
ip_array=( $(who |grep -v root| cut -d"(" -f2 |cut -d")" -f1)) # get data from "who" and some manipulation to get ip 
carrier_array=(); # ip to store carrier from api
for i in ${ip_array[@]} # loop start
do
	#api curl to get carrier of ip and store in carrier_array 
	carrier_array+=($(curl -s "http://ip-api.com/json/"$i"?fields=asname" | jq -r '.asname')) 
done
#getting unique entries in carrier array
unique=($(echo "${carrier_array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
# echo ${unique[@]};
# check if carrier in post data is found in carrier array
if [[ " ${unique[@]} " =~ " ${carrier} " ]]; then
    echo 0; # found carrier
else
	echo 1; # not found carrier
fi
