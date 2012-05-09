#!/bin/bash

#options for RUNMODE are export, import, delete
RUNMODE="export"
STARTDATE="20120201"
#ENDDATE=`/bin/date +%Y%m%d`
ENDDATE="20120214"
REDIS_CLI_PATH=/Users/ripple.khera/tools/redis-2.4.4/src/redis-cli
DOCID_FILE_EXPORT_PATH=/Users/ripple.khera/Documents/Dell_SNA/PostIds
DELETE_SPAM_HASH="Y"

curdate="$STARTDATE"
os=`uname`
RUNMODES=("export" "import" "delete")
DAYS_WITH_FAILURES=("20120101" "20120106" "20120107" "20120124" "20120126" "20120215" "20120217" "20120221" "20120227" "20120304" "20120305" "20120310" "20120312")


function contains()
{
	local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) 
    do
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    done
    echo "n"
    return 1
}

function incr_date()
{
	case $os in
		Darwin*)
			curdate=`/bin/date -j  -v+1d -f %Y%m%d $curdate +%Y%m%d` 
			;;
		Linux*)
			curdate=`/bin/date --date="$curdate 1 day" +%Y%m%d`
			;;	
	esac
}

function export_from_redis() 
{
	echo "Exporting ${curdate} from redis to file postid-day-${curdate}.txt"
	$REDIS_CLI_PATH smembers "PostId|Day|${curdate}" > $DOCID_FILE_EXPORT_PATH/postid-${curdate}.txt 	
}

function import_into_redis()
{
	echo "Importing data from  to redis set PostId|Day|${curdate}" 
	<$DOCID_FILE_EXPORT_PATH/postid-${curdate}.txt xargs -I % $REDIS_CLI_PATH sadd "PostId|Day|${curdate}" % 
}

function delete_data_from_riak()
{
	echo "Deleting data from Riak 1./riak/last-doc-id/${curdate} 2./riak/processed-date-category-map/${curdate}"
	curl -s -XDELETE localhost:8098/riak/last-doc-id/${curdate}
	curl -s -XDELETE localhost:8098/riak/processed-date-category-map/{curdate}
	echo "Deleting data by piping in data from redis PostId|Day|${curdate} and deleting in /riak/filtered-document"	
	$REDIS_CLI_PATH smembers "PostId|Day|${curdate}" | xargs -I % curl -s -XDELETE localhost:8098/riak/filtered-document/%	
}

function delete_data_from_redis()
{
	echo "Deleting data from Redis 1. dcm-${curdate} 2. date-sentsna-list-${curdate}"
	$REDIS_CLI_PATH del "dcm-{curdate}"
	$REDIS_CLI_PATH keys "date-sentsna-list-${curdate}*" | xargs $REDIS_CLI_PATH del   
	
}


##start main##

if [ $(contains "${RUNMODES[@]}" "${RUNMODE}") == "n" ]
	then
		echo "RUNMODE should be export import or delete. Exiting..."
		exit -1
fi

echo "StartDate :"$STARTDATE
echo "EndDate :"$ENDDATE	

until [ "$curdate" == "$ENDDATE" ]
do	
	echo "curdate="$curdate
	if [ $(contains "${DAYS_WITH_FAILURES[@]}" "${curdate}") == "n" ]; 
	then
		case $RUNMODE in
			export) export_from_redis  
			;;
			import) import_into_redis
			;;
			delete) delete_data_from_redis
					delete_data_from_riak
			;;
		esac
	else
		echo "${curdate} is a failed date so skipping"
	fi
	incr_date
done

