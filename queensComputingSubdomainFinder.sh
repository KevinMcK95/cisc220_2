#!/bin/bash

#Kevin McKinnon (10089987) worked on this alone

echo -e "IP Address\tSub-Domain"
queens=130.15
for i in $(seq 0 255); do
	for j in $(seq 0 255); do
		ipNum="$queens.$i.$j"
		result=$(nslookup $ipNum)
		if [[ $result == *"cs.queensu.ca"* ]] ; then
			echo -ne "$ipNum\t"
			web=$(nslookup $ipNum | awk '{print $4}')
			web=($web)
			web=${web[0]:0:$((${#web[0]}-1))} #since the domains end with .ca.
			echo $web
		fi
	done
done
