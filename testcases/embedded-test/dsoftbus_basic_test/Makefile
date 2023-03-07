SUBDIRS=${shell ls | grep -v "Makefile" | grep -v "comm_lib_single.sh" | grep -v "comm_lib_pair.sh" | grep -v "oe_test_dsoftbus_common"}

all: subdirs

subdirs:
	make -C oe_test_dsoftbus_common
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile || exit $$?; done

clean:
	make -C oe_test_dsoftbus_common clean
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean || exit $$?; done
