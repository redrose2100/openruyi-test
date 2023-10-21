######## modify the name to the module name ########
name := kvdo

CURDIR := ${shell pwd}

######## do not modify the following content ###########
CFLAGS_${obj-m}=${PRODUCT}
SOURCES_FILE := $(wildcard *.c)
BINDIR=$(shell echo $(CURDIR) | sed 's/testcases\//bin\//g')
EXTRA_CFLAGS += -D_DEBUG

ifneq ($(KERNELRELEASE),)
	obj-m:=$(name).o
	$(name)-objs := $(patsubst %.c,%.o,$(SOURCES_FILE))
else
	KVER := $(shell uname -r)
	KDIR := /lib/modules/$(KVER)/build
	PWD  := $(shell pwd)

all: clean
	[ -e $(BINDIR) ] || mkdir -p $(BINDIR)
	$(MAKE) -C $(KDIR) M=$(PWD)  modules

clean:
	make -C $(KDIR) M=$(PWD) clean

install:
	echo "the current path is $(CURDIR)"
	if [ -e $(name).ko ]; then cp $(name).ko $(BINDIR); fi;

endif

