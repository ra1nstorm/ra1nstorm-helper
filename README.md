# ra1nstorm helper

The ra1nstorm helper prepares an environment adequate for running checkra1n.

* **[Join us on Discord](https://discord.gg/e9W8cv8)**
* **[Twitter](https://twitter.com/realra1nstorm)**

## Stage1

Stage1 (`stage1/`) contains the Windows-part of the setup and is responsible
for preparing the Linux environment.

## Stage2

Stage2 (`stage2/`) contains the Linux part of the setup and prepares the macOS
VM and automatically configures IOMMU/vfio.

## FAQ

#### 1. Is it legal?

ra1nstorm downloads freely available components like the macOS installer from
official servers. We do not host any components ourselves.

ra1nstorm is 100% legal

#### 2. Does it work on iPads or iPods?

ra1nstorm setup does not currently work with iPads or iPods, but after initial
setup, they should work fine.

#### 3. How do I run checkra1n?

Simply visit the [checkra1n website](https://checkra.in) from within the VM
and follow the instructions.

#### 4. Does this work with AMD CPUs?

ra1nstorm does not currently support AMD CPUs. This is because macOS does not
work properly with them. Please complain to Apple, not us.

#### 5. BootVM tells me that I need to enable "VT-d" or something. How?

Steps for enabling Intel VT-d (IOMMU) vary by motherboard, but are usually like the
following:

1. Enter the computer BIOS (probably F12 on boot)
2. Navigate to an "Advanced" tab
3. Select the "VT-d" or similar option
4. Enable it
5. Reboot

#### 6. Can't I just use Ubuntu from a USB flash drive?

No you cannot. When ra1nstorm forwards the USB controller, your system will crash.

#### 7. Can I use other Linux distros that aren't Ubuntu?

No, they are currently not supported, but probably will be in the future.

## Important Notice

This software is provided WITHOUT WARRANTY in the hopes that it will be useful.
Ronsor Labs does not accept responsibility for any damages that may occur.

This software is *beta quality*. Be careful.

ra1nstorm (C) 2019 Ronsor Labs. This software is licensed under the terms of the
MIT/X11 license.
checkra1n (C) 2019 Kim Jong Cracks. Development by qwertyoruiop, axi0mx, et al.
