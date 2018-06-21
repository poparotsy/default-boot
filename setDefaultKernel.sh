#!/usr/bin/env bash
file="centos6grub.cfg"
#Installed kernels
ik=($(grep Linux $file | awk -F 'Linux' '{print $2}' | awk -F ' ' '{print $1}'))
#kernels count
kc=${#ik[@]}

###############################
# Print out installed kernels 
###############################
	for (( c=0; c<$kc; c++))
	do
		echo " $c ==> ${ik[$c]}"
	done
########################################################
# Set the boot to the highest installed kernel 
########################################################
max=0
index=0
	for ver in ${ik[@]}; do
    	int=`echo $ver | sed 's/\.//'`
    		if (( $int > $max )); 
			then max=$int && highest=$ver && default=$index 
    		fi
	index=$(( $index + 1 ))
	done

echo "set boot to default=$default -- highest is $highest"

sed -i "/^default/s/^default=.*$/default=${default}/g" $file
########################################################
