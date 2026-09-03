SUBDIRS=${shell find . -maxdepth 1 -type d -name "oe_test_*" | sed 's|./||'}
CURDIR=${shell pwd}
COMMONDIR=${CURDIR}

export COMMONDIR

all:copycommon makemake subdirs

copycommon:
	cp -r $${OET_PATH}/testcases/embedded-test/common_libs/* ./

makemake:
	dnf install libtool -y || yum install libtool -y || apt-get install -y libtool || true
	bash ${COMMONDIR}/common.sh -d "make" "openEuler-24.03-LTS"
	cd ./tmp_extract/make* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cp ./make ${CURDIR}
	rm -rf ./tmp_download
	rm -rf ./tmp_extract

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile || exit $$?; done

clean:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean || exit $$?; done
