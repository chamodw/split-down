#!bin/bash
# Chamod Weerasinghe
# Bypass download size limit

# Usage:
#    down.sh -f output_file URL 


#TODO: proxy, more testing 

user_agent="Safari Mac OS X"
#size_limit=94371840
#size_limit=90*1024*1024
size_limit=1024
#width=$(tput cols)


# Command-line options
while getopts 'f:s:u:' opt "$@"; do
    case "$opt" in
        f) file_name="$OPTARG"  ;;
    esac
done

for url in "$@"; do
    y=url
done
if [ "$url" = "" ]
then
	echo "Download Error. Check URL and try again"
	exit 
fi

head=($(curl -I -f -s $url))
er=$?
echo $er
if [ $er -ne 0 ]
then
	echo "Download Error. Check URL and try again"
	exit 
fi
size=${head[6]}
file_size=$(echo $size | tr -d '\r')
echo "Downloading $file_name size: $file_size"
echo $file_size
itr=$(echo "$file_size*1024/$size_limit + 1" | bc)


if  [ -e "$file_name" ]
then
    echo -n "$file_name already exists. Replace(y/n)?  "
    read ans

    if [ "$ans" = "y" ]
    then
        rm $file_name
    else
        echo 'Download aborted'
        exit
    fi


fi

echo "$itr"

#tmp=$(echo "$tmp*$itr"|bc)
#echo -n "0.00%"
#for j in `seq 1 $tmp`;
#do
## echo -n "
#printf "-"
#done
for i in `seq 0 $itr`;
        do
               # echo $(($i*$LIM))
		start=$(($i*$size_limit))
		stop=$(($(($(($i+1))*$size_limit))-1))
		
       # echo "$i of $itr"
		curl   \
            --range "$start"-"$stop"\
            --location\
		--fail \
		-s \
            "$url" >> "$file_name"

        retv=$?
	echo $retv
        if [ $retv -eq 22 ]
        then
		echo 'Download complete'
		break
        fi
	if [ $retv -ne 0 ]
	then
		echo 'Error. Check the URL'
		break
	fi
	
       # n=$(echo "$width/$itr*$i"|bc)
       # percent=$(echo "scale=2;($i/$itr)*100"|bc)
       # printf "\r"
       # echo -n "$percent% "

        #for j in `seq 1 $n`;
        #do
        #    printf "#"
        #done
done
echo
md5 $file_name
        
