#!/bin/bash 

# Thanks to all the nice folks @seemoo-lab for making this possible.
# See: https://github.com/seemoo-lab/nexmon
# This script should be run as root (i.e: sudo ./nexmon.sh) from the /home/pi/ directory!

function info {
	tput bold;
	tput setaf 3;
	echo $1;
	tput sgr0;
}


info "### System Update ###"
apt update 
apt remove wpasupplicant -y
apt autoremove -y
apt upgrade -y

info "### Installing dependencies ###"
apt install raspberrypi-kernel-headers git libgmp3-dev gawk qpdf bison flex make -y

info "### Cloning patched driver repo ###"
git clone https://github.com/seemoo-lab/nexmon.git

if [ -f /usr/lib/arm-linux-gnueabihf/libisl.so.10  ]
	info "### libisl exits, skipping build ###"
else
	info "### Building libisl ###"
	cd /home/pi/nexmon/buildtools/isl-0.10
	./configure
	make
	make install
	ln -s /usr/local/lib/libisl.so /usr/lib/arm-linux-gnueabihf/libisl.so.10
fi

info "### Building tools ###"
cd /home/pi/nexmon/
source setup_env.sh
make

info "### Building patches ###"
cd /home/pi/nexmon/patches/bcm43430a1/7_45_41_46/nexmon/
make

info "### Installing patches ###"
make backup-firmware
make install-firmware

info "### Building monitor mode utility ###"
cd /home/pi/nexmon/utilities/nexutil/
make && make install

info "### Setting reboot options for customized driver  ###"
orig_driver_loc#$(modinfo brcmfmac | grep -o "filename:.*" | cut -f2 -d:)
mv $orig_driver_loc /home/pi/nexmon/brcmfmac.ko.orig
cp /home/pi/nexmon/patches/bcm43430a1/7_45_41_46/nexmon/brcmfmac_kernel49/brcmfmac.ko $orig_driver_loc
depmod -a

echo "Installing PIP ..."
apt install python3-pip -y

info "[SETUP FINISHED]"
