SUBDIRS=${shell ls | grep -v "Makefile" | grep -v "comm_lib_single.sh" | grep -v "comm_lib_pair.sh"}

all: subdirs

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile || exit $$?; done

clean:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean || exit $$?; done
