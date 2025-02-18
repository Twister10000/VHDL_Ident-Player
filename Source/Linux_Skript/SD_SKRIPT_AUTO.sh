#!/bin/bash

function selectfile(){
	clear
		echo "Welches File soll auf die SD_KArte gespeichert werden?"
		sleep 1
		File=$(yad --file)
		clear
		
		echo "Welche SD-Karte soll das Ziel sein?"
		sleep 1
		lsblk
        echo -e  
        read -p "Input:" imagetarget
        clear
}
function Calculate(){
	clear 
	size=$( stat -c '%s' $File )
	size=$(expr $size - 44)
	tail -c $(expr $size) $File > temp.dat	
	ADR_FULL=$(expr $size / 512)
	ADR_FULL=$(expr $ADR_FULL + 1)
	LST_BLK=$(expr $size % 512)
}
function Write(){

		dd of=/dev/$imagetarget if=temp.dat status=progress bs=512
		sync
		sync
}	

selectfile
Calculate
Write
rm temp.dat
echo "SD_CARD_MAX_ADR:"$ADR_FULL
echo "SD_LAST_BLOCK_SIZE:"$LST_BLK
#echo $File
exit
