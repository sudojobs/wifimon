#!/bin/bash

info "Updaing and Installing for Raspberry Pi3b"
sudo apt-get -y update && apt-get -y upgrade
sudo apt-get -y install raspberrypi-kernel-headers git libgmp3-dev gawk qpdf bison flex make

info "Clone the nexmon.git"
git clone https://github.com/seemoo-lab/nexmon.git
cd nexmon
cd buildtools/isl-0.10
./configure
make
make install
ln -s /usr/local/lib/libisl.so /usr/lib/arm-linux-gnueabihf/libisl.so.10

info "Patch for firmware"
cd ../../
source setup_env.sh
make
cd patches/bcm43430a1/7_45_41_46/nexmon/
make
make backup-firmware
make install-firmware

info "Install nexutil"
cd ../../../../
cd utilities/nexutil/
make && make install
cd ../../

info "Remove WpaSupplicant (Optional)"
apt-get -y remove wpasupplicant

info "Patch the Driver"
mv "$(modinfo brcmfmac -n)" "$(modinfo brcmfmac -n).orig"
cp patches/bcm43430a1/7_45_41_46/nexmon/brcmfmac_4.14.y-nexmon/brcmfmac.ko "$(modinfo brcmfmac -n)"
depmod -a
