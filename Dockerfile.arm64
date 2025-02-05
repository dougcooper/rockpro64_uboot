FROM debian

RUN apt update && apt install -y bc python3 libssl-dev make gcc gcc-arm-none-eabi git device-tree-compiler swig bison flex

RUN git clone https://github.com/ARM-software/arm-trusted-firmware.git && cd arm-trusted-firmware && git checkout v2.12.0 && rm -f '*.bin'

WORKDIR /arm-trusted-firmware

RUN make -j$(nproc) PLAT=rk3399 "bl31"

WORKDIR /

RUN git clone --depth 1 --branch v2022.07 https://source.denx.de/u-boot/u-boot.git

WORKDIR /u-boot

RUN make rockpro64-rk3399_defconfig && make -j$(nproc) BL31=/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf

RUN ./tools/mkimage -n rk3399 -T rkspi -d tpl/u-boot-tpl.bin:spl/u-boot-spl.bin idbloader-spi.img
