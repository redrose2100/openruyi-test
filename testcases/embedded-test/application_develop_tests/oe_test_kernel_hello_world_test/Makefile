KERNELDIR := ${KERNEL_SRC_DIR}
ifeq ($(KERNELDIR),)
	KERNELDIR = ${KERNEL_SRC}
endif
CURRENT_PATH := $(shell pwd)

target := kernel_hello_world
obj-m := $(target).o

build := kernel_modules

kernel_modules:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) CC="$(CC)" LD="$(LD)" modules
clean:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) CC="$(CC)" LD="$(LD)" clean
