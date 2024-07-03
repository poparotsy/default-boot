# Technical Document for Kernel Management Script

## Overview

This document provides a detailed explanation of a Bash script designed to manage installed Linux kernels on a CentOS 6 system by updating the GRUB configuration file. The script identifies all installed kernels, prints them out, and sets the default boot option to the highest versioned kernel.

## Script Breakdown

### 1. Script Header

```bash
#!/usr/bin/env bash
```

This shebang line specifies that the script should be executed using the `bash` shell.

### 2. Variables Initialization

```bash
file="centos6grub.cfg"
```

Defines the variable `file` with the value "centos6grub.cfg", which is the GRUB configuration file that will be modified.

### 3. Installed Kernels Extraction

```bash
ik=($(grep Linux $file | awk -F 'Linux' '{print $2}' | awk -F ' ' '{print $1}'))
```

- `grep Linux $file`: Searches for lines containing the word "Linux" in the GRUB configuration file.
- `awk -F 'Linux' '{print $2}'`: Splits each matching line at the word "Linux" and prints the second part.
- `awk -F ' ' '{print $1}'`: Splits the result at spaces and prints the first part, which is the kernel version.
- `ik=($(...))`: Assigns the resulting kernel versions to the array `ik`.

### 4. Kernels Count

```bash
kc=${#ik[@]}
```

Calculates the number of installed kernels by getting the length of the `ik` array.

### 5. Print Out Installed Kernels

```bash
for (( c=0; c<$kc; c++))
do
    echo " $c ==> ${ik[$c]}"
done
```

- `for (( c=0; c<$kc; c++))`: Loops through the indices of the `ik` array.
- `echo " $c ==> ${ik[$c]}"`: Prints the index and corresponding kernel version.

### 6. Set the Boot to the Highest Installed Kernel

#### Initialize Variables

```bash
max=0
index=0
```

- `max`: Variable to store the highest kernel version encountered.
- `index`: Variable to track the index of the current kernel being processed.

#### Determine Highest Kernel

```bash
for ver in ${ik[@]}; do
    int=`echo $ver | sed 's/\.//'`
    if (( $int > $max )); 
    then max=$int && highest=$ver && default=$index 
    fi
    index=$(( index + 1 ))
done
```

- `for ver in ${ik[@]}`: Loops through each kernel version.
- `int=`echo $ver | sed 's/\.//'``: Removes dots from the kernel version string to create an integer for comparison.
- `if (( $int > $max ))`: Compares the current kernel version with the maximum version found so far.
- `then max=$int && highest=$ver && default=$index`: Updates `max`, `highest`, and `default` if the current version is higher.
- `index=$(( index + 1 ))`: Increments the index counter.

### 7. Print the Default Kernel Information

```bash
echo "set boot to default=$default -- highest is $highest"
```

Prints the index of the default kernel and the highest version.

### 8. Update GRUB Configuration

```bash
sed -i "/^default/s/^default=.*$/default=${default}/g" $file
```

- `sed -i`: Runs the `sed` command in-place, modifying the file directly.
- `"/^default/s/^default=.*$/default=${default}/g"`: Searches for the line starting with "default" and replaces it with the new default kernel index.

## Conclusion

This script effectively manages the GRUB configuration to set the default boot kernel to the highest version available. It automates the process of identifying, displaying, and updating the default kernel setting, ensuring the system boots with the latest kernel.
