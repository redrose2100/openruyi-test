SUBDIRS=${shell ls | grep -v "Makefile" | grep -v "common.sh" | grep -v "make" | grep -v "comm_lib.sh"}
CURDIR=${shell pwd}
COMMONDIR=${CURDIR}

export COMMONDIR

all:copycommon makemake subdirs

copycommon:
	cp -r $${OET_PATH}/testcases/embedded-test/common_libs/* ./

makemake:
	yum install libtool -y
	sh ${COMMONDIR}/common.sh -d "make" "openEuler-22.03-LTS"
	cd ./tmp_extract/make* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cp ./make ${CURDIR}
	sh ${COMMONDIR}/common.sh -r all

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile || exit $$?; done

clean:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean || exit $$?; done