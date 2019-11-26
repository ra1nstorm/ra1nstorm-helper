# What an innovative name! new_find_usb_controller!
function new_find_usb_controller(vendorid,\
	lscmd,rdlnk,status,devn,fullpath) {
	lscmd = "ls /sys/bus/usb/devices/*/idVendor | xargs grep -E '^"vendorid"$' | cut -d ':' -f1 | sed 's,/idVendor,,'"
	lscmd | getline devn
	status = close(lscmd)
	if (status != 0) return ""
	if (devn == "") return ""
	rdlnk = "readlink -f " devn
	rdlnk | getline fullpath
	status = close(rdlnk)
	if (status != 0) return ""
#	/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0
	match(fullpath, /\/[^/]+\/0000:([^/]+)\/usb/, a)
	return a[1]
}

function find_usb_controller(driver,\
	lscmd,rdlnk,status,devn,fullpath) {
	lscmd = "ls -d /sys/bus/usb/drivers/" driver "/*:*"
	lscmd | getline devn
	status = close(lscmd)
	if (status != 0) return ""
	if (devn == "") return ""
	rdlnk = "readlink -f " devn
	rdlnk | getline fullpath
	status = close(rdlnk)
	if (status != 0) return ""
#	/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0
	match(fullpath, /\/[^/]+\/0000:([^/]+)\/usb/, a)
	return a[1]
}

function find_vfio_group(pciid,\
	findcmd,vfid) {
	findcmd = "find /sys/kernel/iommu_groups -iname 0000:" pciid
	findcmd | getline vfid
	match(vfid, /\/iommu_groups\/([^/]+)\//, a)
	return a[1]
}

