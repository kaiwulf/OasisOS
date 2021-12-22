#!/bin/zsh
CRTBEGIN=/home/kai/.bin/cross/lib/gcc/i686-elf/10.2.0/crtbegin.o
CRTEND=/home/kai/.bin/cross/lib/gcc/i686-elf/10.2.0/crtend.o

i686-elf-as boot.s -o boot.o
i686-elf-as x86_crti.s -o crti.o
i686-elf-as x86_crtn.s -o crtn.o

i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T linker.ld -o linix.bin -ffreestanding -O2 -nostdlib crti.o CRTBEGIN boot.o kernel.o CRTEND crti.o -lgcc
mv -f linix.bin isodir/boot/linix.bin
grub-mkrescue -o linix.iso isodir
qemu-system-i386 -cdrom linix.iso