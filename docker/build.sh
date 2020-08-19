#!/bin/sh
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

mkdir build
cd build

cmake -DARM_NONE_EABI_TOOLCHAIN_PATH=/opt/gcc-arm-none-eabi-9-2020-q2-update -DNRF5_SDK_PATH=/opt/nRF5_SDK_15.3.0_59ac345 -DUSE_OPENOCD=1 ../
make -j 2

/opt/mcuboot/scripts/imgtool.py create --align 4 --version 1.0.0 --header-size 32 --slot-size 475136 --pad-header src/pinetime-mcuboot-app.bin image.bin
adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application image.bin dfu.zip

mkdir -p output
mv image.bin output/pinetime-mcuboot-app.img
mv dfu.zip output/pinetime-app-dfu.zip

cp src/*.bin /sources/build/output/
cp src/*.hex /sources/build/output/
cp src/*.out /sources/build/output/
cp src/*.map /sources/build/output/
cp ../bootloader/mynewt_nosemi_4.1.7.elf.bin output/bootloader.bin
