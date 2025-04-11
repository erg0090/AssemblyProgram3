#! /bin/bash

echo "Assembling..."
aarch64-linux-gnu-as -o pa3.o pa3.S
sleep 1

echo "Linking..."
aarch64-linux-gnu-gcc -o pa3 pa3.o -nostartfiles
sleep 2

echo "Running..."
echo ""
qemu-aarch64 -L /usr/aarch64-linux-gnu ./pa3

echo ""
echo "Cleaning up..."
rm -f pa3.o pa3
echo "Cleanup complete."