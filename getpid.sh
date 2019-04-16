#!/bin/sh

#logDir="/media/usbstorage0";
logDir=`pwd`
logFile="$logDir/log"
fileSizeLimit=$((1024*1024*10))

checkDirExist(){

        if [ -d "$logDir" ]; then
#                echo "$logDir is exist"
                return 1
        else
                echo " $logDir is not exist"
                return 0
        fi
}

saveFile(){

        fileSize=`ls -l $logFile  | awk '{ print $5 }'`
#        echo $fileSize
        if [ $fileSize -gt $fileSizeLimit ]
        then
                echo "$fileSize > $fileSizeLimit"
                mv $logFile  $logDir"/""`date`".log
#        else
#                echo "$fileSize < $fileSizeLimit"
        fi

}


saveTime(){
        echo "############################" >> $logFile
        date >> $logFile
        echo "############################" >> $logFile
}

savePidMsg(){
        for fileName in $(ls /proc)
        do
                expr $fileName + 0 &>/dev/null
                if [ $? -eq 0 ]; then
                        echo -n "$fileName  " >> $logFile
                        for pidContent in $(ls /proc/$fileName)
                        do
                                echo $pidContent 
                                echo $fileName
                                if [ $pidContent == "comm" ]; then
                                        cat /proc/$fileName/comm >> $logFile
                                fi
                        done
                fi
        done
}

saveDmesg(){

        dmesg -c  >> $logFile
}

run(){

        checkDirExist 
        if [  $? == 1 ];then
                saveTime
                savePidMsg
                saveDmesg
                saveFile
        fi
}

while [ 1 ] 
        do
                sleep 3
                run
        done

