#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/linix.kernel isodir/boot/linix.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "linix" {
	multiboot /boot/linix.kernel
}
EOF
grub-mkrescue -o linix.iso isodir
