#!/bin/sh

git clone https://github.com/ARM-software/arm-trusted-firmware.git 
git clone --depth 1 --branch v2022.07 https://source.denx.de/u-boot/u-boot.git

cd /arm-trusted-firmware
git checkout v2.12.0 && rm -f '*.bin'
make -j$(nproc) PLAT=rk3399 "bl31"

BL31="/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf"

cd /u-boot

make rockpro64-rk3399_defconfig
make -j$(nproc) BL31="$BL31"
./tools/mkimage -n rk3399 -T rkspi -d tpl/u-boot-tpl.bin:spl/u-boot-spl.bin idbloader-spi.img

mkdir -p /output
cp u-boot.itb /output
cp idbloader-spi.img /output
