#!/bin/bash

#Kevin McKinnon (10089987) worked on this alone

list=$(ps axo comm,pid,ppid,start,user | sort -k3n -k2n)
list=($list) #make it an array

declare results
results=(${list[*]:5:5})

for i in $(seq 5 5 $((${#list[*]}-1))); do
	k=$i
	pid=${results[ $(($i-4)) ]}
	for j in $(seq $i 5 $(( ${#list[*]}-1 )) ); do
		if [ "$pid" = "${list[ $(($j+2)) ]}" ]; then
			name=${list[$j]}
			currentPID=${list[$(($j+1))]}
			ppid=${list[$(($j+2))]}
			time=${list[$(($j+3))]}
			user=${list[$(($j+4))]}
			insert=($name $currentPID $ppid $time $user)
			echo $k
			results=(${results[*]:0:$k} ${insert[*]} ${results[*]:$k})
			k=$(($k+5))
		fi
	done
done

for count in $(seq 0 5 $((${#results[*]}-1)) ); do
	name=${list[$count]}
	pid=${list[$(($count+1))]}
	ppid=${list[$(($count+2))]}
	time=${list[$(($count+3))]}
	user=${list[$(($count+4))]}
	echo -e "$name\t\tPID:$pid\t\tPPID:$ppid\t\tSTARTED: $time\tby:$user"
done
