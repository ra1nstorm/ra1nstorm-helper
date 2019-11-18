@include "libzenity.awk"
function execforline(n,\
	ret) {
	n | getline ret
	close(n)
	return ret
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
	} else if (!match(execforline("lscpu | grep Vendor && sleep 1"), /.*GenuineIntel.*/)) {
		print "# Error: this computer does not have an Intel CPU" | h
		failed = 1
	} else if (execforline("df --output=avail $HOME | tail -n1") < (40 * 1024 * 1024)) { # 40GiB
		print "# Error: at least 40G of disk space is required" | h
		failed = 1
	} else if (execforline("cat /proc/meminfo | grep MemTotal | tr -d '[A-Za-z: ]'") < (4.5 * 1024 * 1024)) { # 8GiB
		print "# Error: at least 6G of RAM is required" | h
		failed = 1
	} else if (!match(execforline("lscpu | grep Flags"), /.*vmx.*/)) {
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
	h = zenity_progress("Installing required packages...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")
	# TODO: support other distros?
	for (i = 0; i < length(REQPKGS); i++) {
		print "# Installing " REQPKGS[i] "..." | h
		if (system("apt install -y " REQPKGS[i]) > 0) {
			failed = 1
			break
		}
		print sprintf("%d", 100/length(REQPKGS)*(i+1)) | h
	}
	status = close(h)
	if (!failed) print "# Successfully installed packages" | h
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
	h = zenity_progress("Downloading OSX-KVM (this will take a long time)...", 0, gzenity " --ok-label 'Next' --cancel-label 'Back'")
	print "20" | h
	if (system("test -d /opt/ra1nstorm") == 0) {
	} else if (system("mkdir -p /opt/ra1nstorm && cd /opt/ra1nstorm && git clone https://github.com/kholia/OSX-KVM --depth 1") != 0) {
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

function wizard_next() { wizard_page = wizard_page + 1 }
function wizard_back() { wizard_page = wizard_page - 1 }

BEGIN {
	gtitle = "ra1nstorm"
	gzenity = "--width 800 --height 480"
	split("qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools", REQPKGS, " ")
	wizard[0] = "wiz_intro"
	wizard[1] = "wiz_checksys"
	wizard[2] = "wiz_installreq"
	wizard[3] = "wiz_osxkvm_git"
	while (wizard_page < length(wizard)) {
		wiz_fn_name = wizard[wizard_page]
		wiz_res = @wiz_fn_name()
	}
}
