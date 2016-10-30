#!/bin/bash

#Kevin McKinnon (10089987) worked on this alone

#cron job command: 0 1 * * * /home/kevin/cisc220_2/repositoryBackup.sh &>> backupsLog

filePath=$1
gitURL=$2
user=$3
pass=$4

time=$( date )
time=($time)

year=${time[5]}
month=${time[1]}
day=${time[2]}
clock=${time[3]}

monthList=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for i in $(seq 0 $((${#monthList[*]}-1)) ) ; do
	if [ "$month" = "${monthList[$i]}" ] ; then
		if (( $i < 9 )); then
			month="0$(($i+1))"
		else
			month="$(($i+1))"
		fi
		break
	fi
done

if (( ${#day} == 1 )) ; then
	day="0$day"
fi

fileName=backup$year$month$day${clock:0:2}.tgz
fullPath=$HOME/$filePath
list=$(find $fullPath -type f ! -name 'backup*.tgz')
list=( $list )
declare -a useableFiles

for i in $(seq 0 $((${#list[*]}-1)) ); do
	string=${list[$i]:$((${#fullPath}+1))}
	if [ "${string:0:1}" != "." ]; then
		test=$(ls -Rl )
		useableFiles+=($string)
	fi
done

tar -czf $fullPath/$fileName ${useableFiles[*]}
echo ""
echo "Backup $fileName created sucessfully!"

git add $fullPath/$fileName >> /dev/null
git commit -m "Backup executed" $fullPath/$fileName >> /dev/null
echo Backup $fileName committed to the local git repository
git push --quiet https://$user:$pass@$gitURL --all
echo Backup $fileName pushed to the remote git repository $filePath
