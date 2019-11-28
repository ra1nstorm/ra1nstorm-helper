#!/bin/bash

if [ "$(id -u)" != 0 ]; then
	echo "Run as root."
	exec sudo $0
fi

cd /opt/ra1nstorm
. vmprepare.sh
. vmconfig.sh
cd OSX-KVM

IOMMUERR="IOMMU (VT-d/SR-IOV) is either not supported by your computer or disabled in the BIOS.

Please make sure you have the <b>VT-d</b> or <b>SR-IOV</b> options enabled. They are <b>NOT</b> the same as virtualization technology or VT-x.

Your CPU model is: $(lscpu | grep "Model name" | cut -d: -f2 | sed -E 's/^[ ]+//').
Please check Intel or AMD's website to see if your CPU supports IOMMU technology.
"

test -d /opt/ra1nstorm && ls /sys/kernel/iommu_groups/*/* 2>&1 >/dev/null || zenity --error --title "ra1nstorm" --text "$IOMMUERR" --width 800 --height 480
sh scripts/vfio-group.sh $(find /sys/kernel/iommu_groups -iname 0000:$PCI | cut -d/ -f5)
./boot-macOS-Catalina.sh
sh scripts/vfio-ungroup.sh $(find /sys/kernel/iommu_groups -iname 0000:$PCI | cut -d/ -f5)
