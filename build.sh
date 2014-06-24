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
TOOLCHAIN="/Volumes/Android/cm11/prebuilts/gcc/darwin-x86/arm/arm-eabi-4.7/bin/arm-eabi-"
KERNEL_DIR="/Volumes/Android/kernels/janice"
RAMDISK_DIR="/Volumes/Android/kernels/janice/ramdisk/ramdisk-cwm-touch-6.0.3.3"
MODULES_DIR="$RAMDISK_DIR/lib/modules"
OUT="/Volumes/Android/kernels/out"
DEFCONFIG="GT-I9070_defconfig" # Default
KERNEL=kernel.bin.md5

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
        rm -f scripts/basic/fixdep scripts/conmakehash scripts/genksyms/genksyms scripts/kallsyms scripts/kconfig/conf scripts/mod/mk_elfconfig scripts/mod/modpost
        if [ -a $OUT/$KERNEL ]; then
        	rm -f $OUT/$KERNEL $OUT/Stig.zip
        fi
        ENDTIME=$SECONDS
        $green
		echo -e "Finished in $((ENDTIME-STARTTIME)) Seconds"
		$normal
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

        if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
        then
            echo "Copying modules"
            mkdir -p $MODULES_DIR
            find -name '*.ko' -exec cp -av {} $MODULES_DIR/ \; 
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
        			cd $KERNEL_DIR
        			ENDTIME=$SECONDS
        			echo " "
        			echo " "
        			$green
        			echo "Finished in $((ENDTIME-STARTTIME)) Seconds"
        			echo "DONE, PRESS ENTER TO FINISH"
        			$normal
        			read ANS
        		else
        		    ENDTIME=$SECONDS
        		    $green
            		echo -e "Finished in $((ENDTIME-STARTTIME)) Seconds"
                    $red
                    echo "No compiled zImage at $KERNEL_DIR/arch/arm/boot/zImage"
                    echo "Compilation failed - Fix errors and recompile "
                    echo "Press enter to end script"
                    $normal
                    read ANS
     		    fi
     	else
     	ENDTIME=$SECONDS
     	$green
     	echo "Finished in $((ENDTIME-STARTTIME)) Seconds"
     	$red
     	echo "No compiled zImage at $KERNEL_DIR/arch/arm/boot/zImage"
     	echo "Compilation failed - Fix errors and recompile "
     	echo "Press enter to end script"
     	$normal
     	read ANS
        fi
        ;;
esac

$normal
