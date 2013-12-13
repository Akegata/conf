#!/bin/bash
sleep 20
/sbin/modprobe -r nuvoton-cir
echo 'auto' > "/sys/bus/acpi/devices/NTN0530:00/physical_node/resources"
/usr/bin/sudo /sbin/modprobe nuvoton-cir
