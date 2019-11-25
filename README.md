# ra1nstorm helper
#### No official checkra1n support, no problem!

The ra1nstorm helper prepares an environment adequate for running checkra1n and exploiting your iOS device in a macOS virtual machine.

* **[Join the Discord](https://discord.gg/e9W8cv8)**
* **[Follow the Twitter](https://twitter.com/realra1nstorm)**

## Stage1
##### For Windows Users

Stage1 (`stage1/`) contains the Windows-part of the setup and is responsible
for preparing the Linux environment.

## Stage2
##### For Linux

Stage2 (`stage2/`) contains the Linux part of the setup and prepares the macOS
VM and automatically configures IOMMU/vfio.

## Building
ra1nstorm can be built on most Linux distributions. Ubuntu is the only one tested.
Building ra1nstorm requires ```makeself``` and ```make```. Install both from your package manager to compile, and copy /usr/bin/makeself to /usr/bin/makeself.sh.
To build ra1nstorm.run, simply use ```make ra1nstorm.run```.
Building setup.exe requires Inno Setup 5 installed in C:/Program Files/Inno Setup 5/ISCC.exe using WINE from within Linux. Once installed, run ```make setup.exe``` to build.

## FAQ

#### 1. Is it legal?
##### Yes.
ra1nstorm downloads freely available components like the macOS installer from
official Apple servers. We do not host any components ourselves.

ra1nstorm is 100% legal!

#### 2. Does it work on iPads or iPods?
##### Yes.
ra1nstorm setup *should* currently work with all supported iPads or iPods, as long as they are supported by checkra1n.

#### 3. How do I run checkra1n?
##### Like you normally would.
Simply visit the [checkra1n website](https://checkra.in) from within the VM
and follow the instructions.

#### 4. Does this work with AMD CPUs?
##### Yes.
Yes it does. Make sure AMD-V is on.

#### 5. BootVM tells me that I need to enable "VT-d" or something. How?
##### Enable VT-D.
Steps for enabling Intel VT-d/SR-IOV (IOMMU) vary by motherboard, but are usually like the
following:

1. Enter the computer BIOS (probably F12 on boot)
2. Navigate to the "Advanced" tab or something similar
3. Select the "VT-d", "SR-IOV", or a similar option
4. Enable it
5. Reboot

#### 6. Can't I just use Ubuntu from a USB flash drive?
##### NO!
No you cannot. When ra1nstorm forwards the USB controller to MacOS, your system will crash.

#### 7. Can I use other Linux distros that aren't Ubuntu?
##### No.
No, they are currently not supported, but probably will be in the future.
###### Well, actually, you can, sorta. Follow the instructions at [macOS-Simple-KVM](https://github.com/foxlet/macOS-Simple-KVM), but this is not supported by ra1nstorm and you're basically on your own.

#### 8. I can't boot Xubuntu. I get a security error.
##### Disable Secure Boot.
You need to disable Secure Boot in your BIOS. It varies by motherboard and computer,
but it is generally simple to do and the option is always labeled `Secure Boot`.

## Important Notice

This software is provided WITHOUT WARRANTY in the hopes that it will be useful.
Ronsor Labs does not accept responsibility for any damages that may occur.

This software is *beta quality*. Be careful.

ra1nstorm (C) 2019 Ronsor Labs. This software is licensed under the terms of the
MIT/X11 license.

checkra1n (C) 2019 Kim Jong Cracks. Development by qwertyoruiop, axi0mx, et al.

Thanks to the creator of OSX-KVM and all contributors.


