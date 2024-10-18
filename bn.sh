#!/bin/bash
# Given year and gender, output list of whitespace-separated names from standard input and print rank of each name.
# Danny Dai, 400505160, 2024/10/20

# Check for input errors
# Wrong number of inputs -> exit code 1
if [[ $# != 2 ]]
then
	echo "bn <year> <assigned gender f|F|m|M|b|B>" >&2
	exit 1
fi

# Wrong year or gender-> exit code 2
if ! [[ $1 =~ ^[0-9]{4}$ ]]; then
	echo "Badly formatted year: $1" >&2
	echo "bn <year> <assigned gender f|F|m|M|b|B>" >&2
	exit 2
elif ! [[ $2 =~ ^[fmFMbB]$ ]]; then
        echo "Badly formatted assigned gender: $2" >&2
	echo "bn <year> <assigned gender f|F|m|M|b|B>" >&2
        exit 2
fi

# File does not exist -> exist code 4
if ! [[ -f "us_baby_names/yob$1.txt" ]]; then
	echo "No data for $1"
	exit 4
fi

# Ask for line input and check if error
### DONE ###CHANGE TO WHILE READ LINE, ADD HINT STDOUT FOR NO MATCH
###CHECK IF TXT FILE EXISTS
while read line
do 

	# Name contains more than alphabetical characters -> exit code 3
    	#if ! [[ $line =~ ^[[:alpha:][:space:]]+$ ]]; then
        #	echo "Badly formatted name: $line" >&2
        #	exit 3
   	#fi

    	# process line
    	for arg in $line
    	do

		# Name contains more than alphabetical characters -> exit code 3
       		if ! [[ $arg =~ ^[[:alpha:]]+$ ]]; then
                	echo "Badly formatted name: $arg" >&2
                	exit 3
        	fi

	    	# For Female
            	if [[ $2 =~ [fF] ]]; then
                    	rank=$(cat "us_baby_names/yob$1.txt" | sort -t, -k3nr -k1 | grep -P ",F," | grep -inP "^$arg,F" | cut -d: -f1)
               	    	total=$(cat "us_baby_names/yob$1.txt" | grep -P ",F," | wc -l)

		    	if ! [[ $rank =~ . ]]; then
			    	echo "$1: $arg not found among female names."
		    	else
			    	echo "$1: $arg ranked $rank out of $total female names."
		    	fi
	    	# For Male
            	elif [[ $2 =~ [mM] ]]; then
                    	rank=$(cat "us_baby_names/yob$1.txt" | sort -t, -k3nr -k1 | grep -P ",M," | grep -inP "^$arg,M" | cut -d: -f1)
                    	total=$(cat "us_baby_names/yob$1.txt" | grep -P ",M," | wc -l)
                    	if ! [[ $rank =~ . ]]; then
                            	echo "$1: $arg not found among male names."
                    	else    
			    	echo "$1: $arg ranked $rank out of $total male names."
		    	fi
            	# For Both
	    	elif [[ $2 =~ [bB] ]]; then
                    	rankF=$(cat "us_baby_names/yob$1.txt" | sort -t, -k3nr -k1 | grep -P ",F," | grep -inP "^$arg,F" | cut -d: -f1)
                    	totalF=$(cat "us_baby_names/yob$1.txt" | grep -P ",F," | wc -l)
                    	rankM=$(cat "us_baby_names/yob$1.txt" | sort -t, -k3nr -k1 | grep -P ",M," | grep -inP "^$arg,M" | cut -d: -f1)
                    	totalM=$(cat "us_baby_names/yob$1.txt" | grep -P ",M," | wc -l)
                    	if ! [[ $rankM =~ . ]]; then
                            	echo "$1: $arg not found among male names."
		    	else
			    	echo "$1: $arg ranked $rankM out of $totalM male names."
		    	fi
		    	if ! [[ $rankF =~ . ]]; then
                            	echo "$1: $arg not found among female names."
		    	else
			    	echo "$1: $arg ranked $rankF out of $totalF female names."
		    	fi
            	fi
    	done
done
