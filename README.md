loosely adapted from https://wiki.gentoo.org/wiki/PINE64_ROCKPro64/Installing_U-Boot

## Flash sd card

```
cp idbloader-spi.img u-boot.itb /mnt/card
```

## Pre-flight checks
 
 > Warning: ROCKPro64 will attempt to boot from SPI Flash as first priority. If a bad image is flashed, you will need to disable SPI Flash in order to boot from eMMC or microSD!
Before proceeding, let's be sure we can unbrick the device if something goes wrong.

Make sure you have a:

* microSD (or eMMC) with working U-Boot
* working serial adapter to see early boot messages
* jumper cable to connect two adjacent pins

SPI Flash can be disabled by grounding the SPI clock. Unplug the device from power and connect pin 23 (SPI1_CLK) to pin 25 (GND) on the PI2 Bus. Connect to UART, and insert the bootable card. Then, power on the device and press a key to interrupt boot:

Now that you're in the U-Boot prompt, scan for SPI Flash. It should not be available:

```
sf probe
#jedec_spi_nor flash@0: unrecognized JEDEC id bytes: ff, ff, ff
#Failed to initialize SPI flash at 1:0 (error 0)
```

Now, disconnect pins 23 and 25 and probe again:

```
sf probe
#SF: Detected gd25q128 with page size 256 Bytes, erase size 4 KiB, total 16 MiB
```

To wipe SPI Flash, you can run:

```
sf erase 0 400000
#SF: 4194304 bytes @ 0x0 Erased: OK
```

 Note
ROCKPro64's SPI flash has about 100,000 erase cycles per sector and no wear leveling
Write to SPI flash
Boot using microSD/eMMC created earlier and interrupt boot to enter the U-Boot shell.

Substitute mmc 1:1 below with the device/partition number containing your images. mmc 1:1 is the first partition on the microSD. For example, the third partition on eMMC would be mmc 0:3.

Run the following commands to flash the images:

```
sf probe
load mmc 1:1 $kernel_addr_r idbloader-spi.img
sf erase 0 +$filesize
sf write $kernel_addr_r 0 $filesize
load mmc 1:1 ${kernel_addr_r} u-boot.itb
sf erase 0x60000 +$filesize
sf write $kernel_addr_r 0x60000 ${filesize}
```

To reboot, run:

```
reset
```

Output will be similar to booting from microSD/eMMC as above, except in the serial console you should see:

```
Trying to boot from SPI
```