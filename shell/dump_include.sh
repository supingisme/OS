#!/bin/bash  

name=`sed  -n '/include/p' $1 | awk -F'"'  '{print $2}'`

echo $name
echo "=================="
dumpfile(){
	for i in $@
	do 
		nameson=`sed  -n '/include/p' $i | awk -F'"'  '{print $2}'`
		 if [ $i ]; then
			echo $i
		 fi 
		dumpfile $nameson	
	done
	echo "------------------"
}

dumpfile $name 


  
 

