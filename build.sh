#!/bin/bash 
#
# Kernel Build script for GT-I9070
#
# Written by Aditya Patange aka Adi_Pat adithemagnificent@gmail.com 
#
# TO BUILD THE KERNEL- 
#
# Edit TOOLCHAIN path and INITRAMFS path accordingly. 
#
# .version-number (default is 0)
#
# EXAMPLE: ./build.sh 10
# Pass as a parameter
# 

## Misc Stuff ##

red='tput setaf 1'
green='tput setaf 2'
yellow='tput setaf 3'
blue='tput setaf 4'
violet='tput setaf 5'
cyan='tput setaf 6'
normal='tput sgr0'

### ### ### ### 


# SET SOME PATH VARIABLES
# Modify these as per requirements
ROOT="/Volumes/Android"
# Toolchain path = 
TOOLCHAIN="/Volumes/Android/cm10.1/prebuilts/gcc/darwin-x86/arm/arm-eabi-4.6/bin/arm-eabi"
KERNEL_DIR="/Volumes/Android/kernels/janice"
RAMDISK_DIR="/Volumes/Android/kernels/janice/ramdisk/ramdisk-cwm-touch-6.0.3.3"
MODULES_DIR="$RAMDISK_DIR/lib/modules"
OUT="/Volumes/Android/kernels/out"
DEFCONFIG="GT-I9070_defconfig" # Default
KERNEL=kernel.bin.md5

# More Misc stuff
echo $2 > VERSION
VERSION='cat VERSION'
clear
clear
clear
clear

###################### DONE ##########################
$cyan
echo "***********************************************"
echo "|~~~~~~~~COMPILING The Stig KERNEL ~~~~~~~~~~~|"
echo "|---------------------------------------------|"
$yello
echo "***********************************************"
echo "-----------------------------------------------"
$red
echo "--------- Toni5830 @ XDA-DEVELOPERS -----------"
$yello
echo "-----------------------------------------------"
echo "***********************************************"
$normal

echo ">> Cleaning source"
make clean

# Clean old built kernel in out folder 
if [ -a $OUT/$KERNEL ]; then
rm -r $OUT
rm $KERNEL_DIR/$KERNEL
fi

# Import Defconfig
make $DEFCONFIG

# Build Modules
echo ">> COMPILING!"
echo ">> Building Kernel" 
make -j4 ARCH=arm CROSS_COMPILE=$TOOLCHAIN-
$normal
echo "Copying modules"
find -name '*.ko' -exec cp -av {} $MODULES_DIR/ \;

# Build zImage
echo ">> Building zImage"
cd $KERNEL_DIR 
make -j4 zImage ARCH=arm CROSS_COMPILE=$TOOLCHAIN-
$normal
if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
echo "Preparing Kernel......"
cd $ROOT
mkdir $OUT
cp $KERNEL_DIR/arch/arm/boot/zImage $OUT/kernel.bin
# Make md5
cd $OUT
md5sum -t kernel.bin >> kernel.bin
mv kernel.bin kernel.bin.md5
$yellow
echo "kernel.bin.md5 at $OUT/kernel.bin.md5"
# Remove VERSION File if exists
$cyan
echo "DONE, PRESS ENTER TO FINISH"
$normal
read ANS
else
$red
echo "No compiled zImage at $KERNEL_DIR/arch/arm/boot/zImage"
echo "Compilation failed - Fix errors and recompile "
echo "Press enter to end script"
# Remove VERSION file if exists
$normal
read ANS
fi
 
