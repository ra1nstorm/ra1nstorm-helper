#!/bin/bash

cd /opt/ra1nstorm
. vmprepare.sh
. vmconfig.sh
cd OSX-KVM

sh scripts/vfio-group.sh $(find /sys/kernel/iommu_groups -iname 0000:$PCI | cut -d/ -f5)
./boot-macOS-Catalina.sh
