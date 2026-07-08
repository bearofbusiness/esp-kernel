if [ -z "$NIX_BINTOOLS"]; then
    echo "error: Enter the dev shell 'nix develop' then run again"
    exit 1
fi
zig build --release=small
esptool --chip esp32 elf2image --flash-mode dio --flash-freq 40m --flash-size 4MB -o zig-out/bin/bear32.bin zig-out/bin/bear32
esptool --chip esp32 -p /dev/ttyUSB0 write-flash 0x1000 zig-out/bin/bear32.bin
picocom -b 115200 /dev/ttyUSB0