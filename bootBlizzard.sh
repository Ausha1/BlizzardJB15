#!/bin/bash
echo "Preparing to boot Blizzard Jailbreak's patched boot chain...";
echo "  -- Checking device status..."
deviceConn="`irecovery -q | grep checkm8`"
deviceDFU="`irecovery -q | grep DFU`"

if [ "$deviceConn" = "PWND: checkm8" ]; then
   echo "Device is in PWNED DFU MODE! Proceeding..."
   echo "Sending patched iBSS..."
   irecovery -f iBSS.img4
   sleep 1
   echo "Sending patched iBEC..."
   irecovery -f iBEC.img4
   sleep 1
   echo "Booting patched iBEC..."
   irecovery -c go
   sleep 1
   irecovery -c bootx
   echo "Sending Blizzard Jailbreak Logo..."
   irecovery -f logo.img4
   irecovery -c "setpicture 0"
   irecovery -c "bgcolor 233 233 233"
   echo "Sending patched DeviceTree (rdtr)..."
   irecovery -f devicetree.img4
   irecovery -c devicetree
   echo "Sending patched ROOT FS Trustcache..."
   irecovery -f trustcache.img4
   irecovery -c firmware
   echo "Sending patched KernelCache..."
   irecovery -f kernelcache.img4
   sleep 2
   echo "Sending patched KernelCache..."
   irecovery -f bootx
elif [ "$deviceDFU" = "MODE: DFU" ]; then
   echo "Device is in DFU mode, but not in PWNED DFU."
else
   echo "Device is not connected / not in DFU mode / not in PWNED DFU mode."
fi
