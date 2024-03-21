CFLAGS	= -g 

all: mm_uce_ioctl_ko user_mm_uce_test

clean:
	rm -f *.o user_mm_uce_test 
	make -C  mm_uce_ioctl clean

user_mm_uce_test:proc_pagemap.o user_mm_uce_test.o mm_uce_trace_phys_addr_event.o 
	cc -o user_mm_uce_test  ${CFLAGS} user_mm_uce_test.o  proc_pagemap.o mm_uce_trace_phys_addr_event.o -I.

mm_uce_ioctl_ko:
	make -C  mm_uce_ioctl

install:all
	install -m 0744 -p -D user_mm_uce_test	      /usr/bin/user_mm_uce_test
	install -m 0744 -p -D mm_uce_ioctl/*.ko          /lib/modules/`uname -r`/kernel/mm/ 
	depmod -a
uninstall:
	rm -rf /usr/bin/user_mm_uce_test
	rm -rf /lib/modules/`uname -r`/kernel/mm/mm_uce_ioctl.ko
	depmod -a


