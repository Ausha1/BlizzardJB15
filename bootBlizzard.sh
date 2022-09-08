#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[1;36m'
Green='\033[0;32m'

printf "\033c"
echo "* Blizzard Jailbreak Booter v1.0 ~ Alpha 1 *"
echo "* by a half-asleep GeoSn0w *"
printf "\n"
echo -e "${CYAN}INFO${NC} Checking minimum dependencies..."

if ! command -v irecovery &> /dev/null
then
    echo -e "${RED}FAIL${NC} libirecovery is not installed on this Mac. Do brew install libirecovery."
    exit
else
    echo -e "${Green}SUCCESS${NC} libirecovery is properly installed. Continuing..."
fi

if ! command -v python3 &> /dev/null
then
    echo -e "${RED}FAIL${NC} Python3 is not installed on this Mac. Do brew install python@3."
    exit
else
    echo -e "${Green}SUCCESS${NC} Python3 is properly installed. Continuing..."
fi

echo -e "${CYAN}INFO${NC} Preparing to boot Blizzard Jailbreak's patched boot chain...";

echo -e "${CYAN}INFO${NC} Attempting to put the device in PWNED DFU mode...";
cd pyboot
python3 pyboot.py -p
cd ..

echo -e "${CYAN}INFO${NC} Checking device status..."
deviceConn="`irecovery -q | grep checkm8`"
deviceDFU="`irecovery -q | grep DFU`"

if [ "$deviceConn" = "PWND: checkm8" ]; then
    serialAvailable="`ls /dev/cu.usbserial*`"
    
    if [[ "$serialAvailable" =~ .*"/dev/cu.usbserial".* ]]; then
        echo -e "${Green}INFO${NC} DCSD is available. You may monitor the boot process with termz and device $serialAvailable"
    fi
    
    echo -e "${Green}SUCCESS${NC} Device is in PWNED DFU MODE! Continuing..."
    echo -e "${CYAN}INFO${NC} Sending patched iBSS..."
        irecovery -f iBSS.img4
        sleep 1
    echo -e "${CYAN}INFO${NC} Sending patched iBEC..."
        irecovery -f iBEC.img4
        sleep 1
    echo -e "${CYAN}INFO${NC} Booting patched iBEC..."
        irecovery -c go
        sleep 1
        irecovery -c bootx
    echo -e "${CYAN}INFO${NC} Sending Blizzard Jailbreak Logo..."
        irecovery -f logo.img4
        irecovery -c "setpicture 0"
        irecovery -c "bgcolor 233 233 233"
    echo -e "${CYAN}INFO${NC} Sending patched DeviceTree (rdtr)..."
        irecovery -f devicetree.img4
        irecovery -c devicetree
    echo -e "${CYAN}INFO${NC} Sending patched ROOT FS Trustcache..."
        irecovery -f trustcache.img4
        irecovery -c firmware
    echo -e "${CYAN}INFO${NC} Sending patched KernelCache..."
        irecovery -f kernelcache.img4
        sleep 2
    echo -e "${CYAN}INFO${NC} Sending patched KernelCache..."
        irecovery -f bootx
    printf "\n"
    echo -e "${CYAN}**********************************************"
    echo "In a perfect world, everything should boot up."
    echo "Please monitor the device with DCSD and termz. iBEC and iBSS are patched to redirect Kernel's debug messages to serial."
    echo -e "${CYAN}**********************************************"
    exit
elif [ "$deviceDFU" = "MODE: DFU" ]; then
    echo -e "${RED}FAIL${NC} Device is in DFU mode, but not in PWNED DFU."
else
    echo -e "${RED}FAIL${NC} Device is not connected / not in DFU mode / not in PWNED DFU mode."
fi
