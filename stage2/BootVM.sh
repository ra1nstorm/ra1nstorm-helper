#!/bin/bash

if [ "$(id -u)" != 0 ]; then
	echo "Run as root."
	exec sudo $0
fi

cd /opt/ra1nstorm
. vmprepare.sh
. vmconfig.sh
cd OSX-KVM

ls /sys/kernel/iommu_groups/*/* 2>&1 >/dev/null || zenity --error --title "ra1nstorm" --text "Failed to initialize IOMMU. Please make sure IOMMU (or VT-d) is enabled in the advanced settings in your BIOS."
sh scripts/vfio-group.sh $(find /sys/kernel/iommu_groups -iname 0000:$PCI | cut -d/ -f5)
./boot-macOS-Catalina.sh
