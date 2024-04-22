ifneq  ($(KERNELRELEASE),)
	obj-m:=mm_uce_ioctl.o
else

KDIR := /lib/modules/$(shell uname -r)/build/
INCLUDES = -I. -I$(KDIR)/include
CFLAGS= -O0
PWD:=$(shell pwd)
all:
	yes|cp -f mm_uce_trace_event.h ${KDIR}/include/trace/events/ 
	make -C $(KDIR) M=$(PWD) modules 
clean:
	rm -f *.ko *.o *.symvers *.cmd *.cmd.o *.mod.c modules.order *.mod .*.cmd .*.ko .*.mod
endif
