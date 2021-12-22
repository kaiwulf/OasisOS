# DEFAULT_HOST!=../default-host.sh
DEFAULT_HOST=i386
HOST?=$(DEFAULT_HOST)
HOSTARCH!=../target-triplet-to-arch.sh $(HOST)

AS=i686-elf-as
CC=i686-elf-gcc

CFLAGS?=-O2 -g
CPPFLAGS?=
LDFLAGS?=
LIBS?=

DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
BOOTDIR?=$(EXEC_PREFIX)/boot
INCLUDEDIR?=$(PREFIX)/include

CFLAGS:=$(CFLAGS) -ffreestanding -Wall -Wextra
CPPFLAGS:=$(CPPFLAGS) -D__is_kernel -Iinclude
LDFLAGS:=$(LDFLAGS)
# LIBS:=$(LIBS) -nostdlib -lk -lgcc
LIBS:=$(LIBS) -nostdlib -lgcc -static 

ARCHDIR=arch/$(HOSTARCH)
CROSSDIR=/home/kai/.bin/cross/lib/gcc/i686-elf/10.2.0
LIBC=/home/kai/proj/OasisOS/sysroot/libc/libc.a

include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

KERNEL_OBJS=\
$(KERNEL_ARCH_OBJS) \
kernel/kernel.o \



OBJS=\
$(ARCHDIR)/crti.o \
$(ARCHDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(ARCHDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

LINK_LIST=\
$(LDFLAGS) \
$(ARCHDIR)/crti.o \
$(CROSSDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(LIBS) \
$(LIBC) \
$(CROSSDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

.PHONY: all clean install install-headers install-kernel
.SUFFIXES: .o .c .S

all: linix.bin

linix.bin: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot linix.bin

$(ARCHDIR)/crtbegin.o $(ARCHDIR)/crtend.o:
	OBJ=`$(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=$(@F)` && cp "$$OBJ" $@

.c.o:
	$(CC) -MD -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

.S.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

kernel: kernel.c
	$(CC) kernel.c $(LIBK) -o kernel.o $(CFLAGS)

crti.o: x86_crti.s
	$(AS) x86_crti.s -o $(ARCHDIR)/crti.o

crtn.o: x86_crtn.s
	$(AS) x86_crtn.s -o $(ARCHDIR)/crtn.o

crt0.o: x86_crt0.s
	$(AS) x86_crt0.s -o $(ARCHDIR)/crt0.o

boot.o: $(ARCHDIR)/boot.s
	$(AS) $(ARCHDIR)/boot.s -o $(ARCHDIR)/boot.o

clean:
	rm -f linix.bin
	rm -f $(OBJS) *.o */*.o */*/*.o
	rm -f $(OBJS:.o=.d) *.d */*.d */*/*.d

install: install-headers install-kernel

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-kernel: linix.bin
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp linix.bin $(DESTDIR)$(BOOTDIR)

-include $(OBJS:.o=.d)
