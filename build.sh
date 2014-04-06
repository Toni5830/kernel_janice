#!/bin/bash 

#
# Kernel Build script for GT-I9070
#
# TO BUILD THE KERNEL:
#
# Edit TOOLCHAIN path and INITRAMFS path accordingly. 
# ./build.sh
#

## Misc Stuff ##

red='tput setaf 9'
green='tput setaf 34'
cyan='tput setaf 39'
normal='tput sgr0'

### ### ### ### 


# SET SOME PATH VARIABLES
# Modify these as per requirements
ROOT="/Volumes/Android/kernels"
# Toolchain path = 
TOOLCHAIN="/Volumes/Android/omni4.4/prebuilts/gcc/darwin-x86/arm/arm-eabi-4.6/bin/arm-eabi-"
KERNEL_DIR="/Volumes/Android/kernels/janice"
RAMDISK_DIR="/Volumes/Android/kernels/janice/ramdisk/ramdisk-cwm-touch-6.0.3.3"
MODULES_DIR="$RAMDISK_DIR/lib/modules"
OUT="/Volumes/Android/kernels/out"
DEFCONFIG="GT-I9070_defconfig" # Default
KERNEL=kernel.bin.md5
FAIL="ENDTIME=$SECONDS \
                    echo -e "\n\n Finished in $((ENDTIME-STARTTIME)) Seconds\n\n" \
                    $red \
                    echo "No compiled zImage at $KERNEL_DIR/arch/arm/boot/zImage" \
                    echo "Compilation failed - Fix errors and recompile " \
                    echo "Press enter to end script" \
                    $normal \
                    read ANS"
DONE="ENDTIME=$SECONDS \
        			echo -e "\n\n Finished in $((ENDTIME-STARTTIME)) Seconds\n\n" \
        			$cyan \
        			echo "DONE, PRESS ENTER TO FINISH" \
        			$normal \
        			read ANS"

# More Misc stuff
STARTTIME=$SECONDS
clear
clear
clear
clear

###################### DONE ##########################
$cyan
echo "***********************************************"
echo "|~~~~~~~~COMPILING The Stig KERNEL ~~~~~~~~~~~|"
echo "|---------------------------------------------|"
echo "***********************************************"
echo "-----------------------------------------------"
echo "--------- Toni5830 @ XDA-DEVELOPERS -----------"
echo "-----------------------------------------------"
echo "***********************************************"
$normal

case "$1" in
    c)
		make clean
        rm -rf include/generated include/config
        rm -f .config .version .config.old Module.symvers
        if [ -a $OUT/$KERNEL ]; then
        	rm -f $OUT/$KERNEL $OUT/Stig.zip
        fi
        ENDTIME=$SECONDS
		echo -e "\n\n Finished in $((ENDTIME-STARTTIME)) Seconds\n\n"
    ;;

    *) if [ -z $1 ]; then
        set 1
        fi
         
		# Import Defconfig
        make $DEFCONFIG

        # Build kernel
        echo ">> COMPILING!"
        echo ">> Building Kernel" 
        make -j$1 ARCH=arm CROSS_COMPILE=$TOOLCHAIN
        $normal
        echo "Copying modules"
        find -name '*.ko' -exec cp -av {} $MODULES_DIR/ \;

        if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
        then

      	    # Build zImage
        	echo ">> Building zImage"
        	cd $KERNEL_DIR 
     	    make -j$1 zImage ARCH=arm CROSS_COMPILE=$TOOLCHAIN
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
        			zip -r Stig.zip META-INF kernel.bin.md5

        			$DONE
        		else
                    $FAIL
     		    fi
        else
           $FAIL
        fi
        ;;
esac

$normal
