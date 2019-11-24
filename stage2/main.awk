@include "libzenity.awk"
@include "usbutil.awk"
function execforline(n,\
	ret) {
	n | getline ret
	close(n)
	return ret
}

function cpu_is_intel() {
	return system("lscpu | grep 'Model name' | grep -q Intel") == 0
}

function wiz_intro() {
	if (zenity_html("./intro.html", 0, gzenity " --ok-label 'Get Started' --cancel-label 'Exit'") == 0) {
		wizard_next()
	} else {
		exit(0)
	}
}

function wiz_checksys(\
	h, status, failed) {
	h = zenity_progress("Checking your system for compatibility...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")

	print "20" | h
	# Now we check the system configuration
	if (!match(execforline("id -u"), /^0/)) {
		print "# Error: you need to run ra1nstorm as root" | h
		failed = 1
	#} else if (!match(execforline("lscpu | grep Vendor && sleep 1"), /.*GenuineIntel.*/)) {
	#	print "# Error: this computer does not have an Intel CPU" | h
	#	failed = 1
	} else if (execforline("df --output=avail $HOME | tail -n1") < (40 * 1024 * 1024) &&
		system("test -d /opt/ra1nstorm/OSX-KVM") != 0) { # 40GiB
		print "# Error: at least 40G of disk space is required" | h
		failed = 1
	} else if (execforline("cat /proc/meminfo | grep MemTotal | tr -d '[A-Za-z: ]'") < (3 * 1000 *  1000)) { # 4GiB. This is probably a bad idea.
		print "# Error: at least 4G of RAM is required" | h
		failed = 1
	} else if (system("test -e /dev/kvm") != 0) {
		print "# Error: your CPU does not support hardware virtualization (or it is not enabled in the BIOS)" | h
		failed = 1
	}
	# We've checked the system configuration
	if (!failed) print "# Compatibility check passed" | h
	if (!failed) print "100" | h; else print "80" | h
	status = close(h)
	if (status == 0 && !failed) {
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "Your computer did not meet the minimum requirements for ra1nstorm.")
		exit(1)
	}
}

function wiz_installreq(\
	h, failed, status) {
	h = zenity_progress("Installing required packages (this may take a long time)...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")
	# TODO: support other distros?
	system("apt update")
	for (i = 0; i < length(REQPKGS); i++) {
		print "# Installing " REQPKGS[i] "..." | h
		if (system("apt install -y " REQPKGS[i]) > 0) {
			failed = 1
			print "# Error: failed to install " REQPKGS[i] | h
			break
		}
		print sprintf("%d", 100/length(REQPKGS)*(i+1)) | h
	}
	if (!failed) print "# Successfully installed packages" | h
	status = close(h)
	if (status == 0 && !failed){
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "ra1nstorm failed to install required software for operation.")
		exit(1)
	}
}

function wiz_osxkvm_git(\
	h,status,failed) {
	h = zenity_progress("Downloading OSX-KVM (this may take a long time)...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")
	print "20" | h
	if (system("test -x /opt/ra1nstorm/OSX-KVM/fetch-macOS.py") == 0) {
	} else if (system("mkdir -p /opt/ra1nstorm && cd /opt/ra1nstorm && git clone https://github.com/kholia/OSX-KVM --depth 1") != 0) {
		print "# Error: failed to download OSX-KVM" | h
		failed = 1
	}
	if (!failed) print "# Downloaded OSX-KVM" | h
	status = close(h)
	if (status == 0 && !failed) {
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "ra1nstorm failed to download OSX-KVM")
		exit(1)
	}
}

function wiz_osxkvm_getdmg(\
	h,status,failed,NUM) {
	NUM = 4 # this is awful
	h = zenity_progress("Downloading components... (this may take a long time)...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")
	print "20" | h
	print "# Downloading macOS installation image (this WILL take a long time)..." | h
	if (system("test -f /opt/ra1nstorm/OSX-KVM/BaseSystem.img") == 0) {
	} else if (system("echo " NUM " | (cd /opt/ra1nstorm/OSX-KVM && ./fetch-macOS.py && dmg2img BaseSystem.dmg BaseSystem.img && qemu-img create -f qcow2 mac_hdd_ng.img 32G)")) {
		print "# Failed to download macOS installation image" | h
		failed = 1
	}
	if (!failed) print "# Downloaded macOS installer" | h
	status = close(h)
	if (status == 0 && !failed) {
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "ra1nstorm failed to download the macOS installer")
		exit(1)
	}
}

function wiz_bootinst(\
	h,status,failed) {
	h = zenity_progress("Booting macOS Setup...", 0, gzenity " --ok-label 'See Instructions' --cancel-label 'Back'")
	print "40" | h
	failed = system("(cp vmprepare.txt /opt/ra1nstorm/vmprepare.sh && sh /opt/ra1nstorm/vmprepare.sh && cd /opt/ra1nstorm/OSX-KVM && ./boot-macOS-Catalina.sh &)")
	if (!failed) print "# Please click \"See Instructions\" to see the steps you need to take." | h
	status = close(h)
	if (status == 0 && !failed) {
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "ra1nstorm failed to initialize the macOS installer")
		exit(1)
	}
	close(h)
}

function wiz_bootinstructions() {
	if (zenity_html("./installerhelp.html", 0, gzenity " --ok-label 'I Have Finished Setup' --cancel-label 'Exit'") == 0) {
		wizard_next()
	} else {
		exit(0)
	}
}

function wiz_configiommu(\
	h,status,failed,pciid,cpumanf) {
	cpumanf = "intel"
	if (!cpu_is_intel()) cpumanf = "amd"
	zenity_alert("info", "ra1nstorm will now attempt to detect which USB controller to forward.\n" \
				"Please disconnect all other USB devices (except your keyboard and/or mouse) and connect ONLY your iPhone directly to your computer.\n" \
				"Do NOT use a USB hub or any similar gadgets.\n\nPress OK to continue.")
	h = zenity_progress("Autodetecting USB configuration...", 0, gzenity " --ok-label 'Reboot' --cancel-label 'Back'")
	print "20" | h
	pciid = ""
	while (pciid == "") {
		print "# Locating USB controller..." | h
		pciid = find_usb_controller("ipheth")
		print "debug! pciid="pciid
		if (!pciid) {
			system("sleep 1")
			print "20" | h
			print "# Still locating USB controller... (plug in your iPhone)" | h
		}
	}
	print "45" | h
	print "# Patching GRUB..." | h
	ok = system("cp /etc/modules /etc/modules.bak && cp /etc/default/grub /etc/default/grub.bak && echo vfio >> /etc/modules && echo vfio_iommu_type1 >> /etc/modules && echo vfio_pci >> /etc/modules && echo vfio_virqfd >> /etc/modules &&" \
		"sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"iommu=pt amd_iommu=on intel_iommu=on /' /etc/default/grub &&" \
		"echo 'options vfio-pci ids=" pciid "' > /etc/modprobe.d/vfio.conf &&" \
		"update-grub2 && update-initramfs -k all -u")
	if (ok != 0)
		failed = 1
	print "70" | h
	print "# Patching boot scripts..." | h
	ok = system("sed -i 's/-vga vmware.*/-vga vmware -device vfio-pci,host=" pciid ",bus=pcie.0/g' /opt/ra1nstorm/OSX-KVM/boot-macOS-Catalina.sh")
	if (ok != 0)
		failed = 1
	print "90" | h
	print "PCI=" pciid > "/opt/ra1nstorm/vmconfig.sh"
	print "Creating shortcuts..." | h
	system("cp 'BootVM.sh' $HOME && cp 'BootVM.sh' $HOME/Desktop && chmod +x $HOME/BootVM.sh && chmod +x $HOME/Desktop/BootVM.sh")
	status = close(h)
	if (status == 0 && !failed) {
		wizard_next()
	} else {
		if (failed)
			zenity_alert("error", "ra1nstorm was unable to configure PCI passthrough for your USB controller")
		exit(1)
	}
	close(h)
}

function wiz_reboot() {
	if (dryrun)
		print "REBOOT NOW!"
	else
		system("reboot")
}

function init_wizard(pg) {
	wizard_page = pg
	if (!wizard_page) wizard_page = 0
	while (wizard_page < length(wizard)) {
		wiz_fn_name = wizard[wizard_page]
		wiz_res = @wiz_fn_name()
	}
}

function wizard_next() { wizard_page = wizard_page + 1 }
function wizard_back() { wizard_page = wizard_page - 1 }

function uninstall(\
	h) {
	if (zenity_alert("question", "Are you sure you want to remove ra1nstorm?") != 0)
		return
	h = zenity_progress("Uninstalling...", 0, gzenity " --ok-label 'Finish' --cancel-label 'Cancel'")
	print "50" | h
	system("rm -rf /opt/ra1nstorm")
	print "90" | h
	system("cp /etc/default/grub.bak /etc/default/grub; cp /etc/modules.bak /etc/modules")
	print "# ra1nstorm has been successfully removed." | h
	close(h)
	if (zenity_alert("question", "ra1nstorm has been removed. You will need to reboot for the changes to take effect.\nReboot now?") == 0) {
		system("reboot")
	}
}

function main_menu(\
	opt,optlist) {
	optlist = "Install"
	if (system("test -d /opt/ra1nstorm") == 0)
		optlist = optlist ";Repair USB/VFIO Config;Boot VM;Uninstall"
	opt = zenity_radiolist(optlist, "Please choose an action")
	if (opt == 1) {
		init_wizard(0)
	} else if (opt == 2) {
		init_wizard(7)
	} else if (opt == 3) {
		system("bash $HOME/BootVM.sh")
	} else if (opt == 4) {
		uninstall()
	} else {
		exit(0)
	}
}

BEGIN {
	gtitle = "ra1nstorm"
	gzenity = "--width 800 --height 480"
	split("qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools", REQPKGS, " ")
	wizard[0] = "wiz_intro"
	wizard[1] = "wiz_checksys"
	wizard[2] = "wiz_installreq"
	wizard[3] = "wiz_osxkvm_git"
	wizard[4] = "wiz_osxkvm_getdmg"
	wizard[5] = "wiz_bootinst"
	wizard[6] = "wiz_bootinstructions"
	wizard[7] = "wiz_configiommu"
	wizard[8] = "wiz_reboot"
	while (1) main_menu()
}
