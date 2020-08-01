#!/usr/bin/env bash

#TODO: make a list of choice
#1, Set upgrade mode.
#2, set replica to numer.
#3, close an index.
#4,

#Variable
#IP 0
#Port 1
#archive dir 2
#username 3
#password 4
#schema 5

inputfile="infofile.txt"
declare -i i=0

while  read line ; do
	variable[$i]=$line
	i=$((i+1))
done <"$inputfile"

upgradeMode () {
    echo "upgrade"
    curl -k -u ${variable[3]}:${variable[4]} -X PUT "${variable[5]}://${variable[0]}:${variable[1]}/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
    {
        "persistent": {
            "cluster.routing.allocation.enable": "primaries"
        }
    }
    '
    curl -k -u ${variable[3]}:${variable[4]} -X POST "${variable[5]}://${variable[0]}:${variable[1]}/_flush/synced?pretty"
    curl -k -u ${variable[3]}:${variable[4]} -X POST "${variable[5]}://${variable[0]}:${variable[1]}/_ml/set_upgrade_mode?enabled=true&pretty"
}

disupgradeMode () {
    curl -k -u ${variable[3]}:${variable[4]} -X PUT "${variable[5]}://${variable[0]}:${variable[1]}/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
    {
        "persistent": {
            "cluster.routing.allocation.enable": null
        }
    }
    '
    curl -k -u ${variable[3]}:${variable[4]} -X POST "${variable[5]}://${variable[0]}:${variable[1]}/_ml/set_upgrade_mode?enabled=false&pretty"

}

replicaTo () {
    curl -k -X PUT -u ${variable[3]}:${variable[4]} "${variable[5]}://${variable[0]}:${variable[1]}/$1/_settings?pretty" -H 'Content-Type: application/json' -d'
	{
		"index" : {
			"number_of_replicas" : '$2'
		}
	}
	'
}

statusDataNode () {
    curl -k -X PUT -u ${variable[3]}:${variable[4]} "${variable[5]}://${variable[0]}:${variable[1]}/_cat/allocation?v"
}

statusElastic () {
    curl -k -X PUT -u ${variable[3]}:${variable[4]} "${variable[5]}://${variable[0]}:${variable[1]}/_cat/health?v"
}

closeIndex () {
    echo "closed"
}

echo "
1, upgrade mode.
2, unset upgrade mode.
3, Set replica to n.
4, Check health.
5, Check data node status."
echo "What is your choice: "; read choice

case $choice in
    1 )
        upgradeMode
        ;;
    2 )
        disupgradeMode
        ;;
    3 )
        echo "What indices would you like to set replica to: "; read indices_patterns;
        echo "Number of replica for that indices: "; read replica_number;
        #echo "$indices_patterns and $replica_number"
        replicaTo $indices_patterns $replica_number
        ;;
    4 )
        statusElastic
        ;;
    5 )
        statusDataNode
        ;;
esac
