obj-m := mem_overloading_kmalloc.o
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(shell pwd) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f *.ko *.o *.mod.o *.mod.c .*.cmd *.symvers modul* *.mod
