OBJS:=boot.o kernel.o
AS=i686-elf-as
CC=i686-elf-gcc
CRTI_OBJ=crti.o
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LFLAGS=-ffreestanding -O2 -nostdlib -lgcc -T -lk
# CRTBEGIN_OBJ:=$(shell $(CC) $(LFLAGS) -print-file-name=crtbegin.o)
# CRTEND_OBJ:=$(shell $(CC) $(LFLAGS) -print-file-name=crtend.o)
CRTBEGIN_OBJ=/home/kai/.bin/cross/lib/gcc/i686-elf/10.2.0/crtbegin.o
CRTEND_OBJ=/home/kai/.bin/cross/lib/gcc/i686-elf/10.2.0/crtend.o
CRTN_OBJ=crtn.o
 
OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)
INTERNAL_OBJS:=$(CRTI_OBJ) $(OBJS) $(CRTN_OBJ)

kernel: kernel.c
	$(CC) kernel.c -o kernel.o $(CFLAGS)

boot: boot.s
	$(AS) boot.s -o boot.o

crti: x86_crti.s
	$(AS) x86_crti.s -o crti.o

crtn: x86_crtn.s
	$(AS) x86_crtn.s -o crtn.o

crt0: x86_crt0.s
	$(AS) x86_crt0.s -o crt0.o

myos: $(OBJ_LINK_LIST)
	$(CC) -o myos.bin $(OBJ_LINK_LIST)
 
clean:
	rm -f myos.kernel $(INTERNAL_OBJS)