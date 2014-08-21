#!/bin/bash
####################################

#ifndef TOSROOT
TOSROOT="/opt/tinyos-2.1.2"  
TOSDIR=$TOSROOT/tos
MAKERULES=$TOSROOT/support/make/Makerules
CLASSPATH=$TOSROOT/support/sdk/java/tinyos.jar:.	
PYTHONPATH=$TOSROOT/support/sdk/python:$PYTHONPATH  
export MAKERULES TOSROOT TOSDIR CLASSPATH PYTHONPATH 
#endif
i=0
from=$1
to=$2
platform=$3

i=$from
port=0

#echo $from $to

echo $(sudo chmod 777 -R /dev/)

while [ $i -le $to ];  do
	make $platform install.$i bsl,/dev/ttyUSB$port
	echo '########################################'
	echo 'done: node_id '$i' port '$port
	echo '########################################'
	port=`expr $port + 1`
	i=`expr $i + 1`
done



#for port in ${ports[@]}; do
	#make telosb install.$port bsl,/dev/ttyUSB$port
	#echo '########################################'
	#echo 'done:'$port
	#echo '########################################'
 #other stuff on $name
#done


