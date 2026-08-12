SUBDIRS=${shell ls -d oe_test_* | grep -v "Makefile"}
CURDIR=${shell pwd}

all:copycommon makemake subdirs

copycommon:
	cp -r $${OET_PATH}/testcases/embedded-test/common_libs/* ./

makemake:
	dnf install libtool -y || yum install libtool -y || apt-get install -y libtool || true
	bash ./common.sh -M "make"
	cd ./tmp_extract/make* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cp ./make ${CURDIR}
	bash ./common.sh -M "dejagnu"
	cd ./tmp_extract/dejagnu* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --prefix=${CURDIR}/dejagnu && \
	make install
	tar -cf dejagnu.tar ./dejagnu
	bash ./common.sh -r all

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile||exit $$?; done
clean:
	rm -rf ./make
	rm -rf dejagnu.tar
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean; done
