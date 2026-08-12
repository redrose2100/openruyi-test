SUBDIRS=${shell ls -d oe_test_* | grep -v "Makefile"}
CURDIR=${shell pwd}

all:copycommon makemake subdirs

copycommon:
	cp -r $${OET_PATH}/testcases/embedded-test/common_libs/* ./ || { bash ./common.sh -r; exit 1; }

makemake:
	dnf install libtool -y || yum install libtool -y || apt-get install -y libtool || true
	bash ./common.sh -M "make" || { bash ./common.sh -r; exit 1; }
	cd ./tmp_extract/make* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cp ./make ${CURDIR} || { bash ./common.sh -r; exit 1; }
	bash ./common.sh -M "dejagnu" || { bash ./common.sh -r; exit 1; }
	cd ./tmp_extract/dejagnu* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --prefix=${CURDIR}/dejagnu && \
	make install || { bash ./common.sh -r; exit 1; }
	tar -cf dejagnu.tar ./dejagnu || { bash ./common.sh -r; exit 1; }
	bash ./common.sh -r

subdirs:
	for subdir in ${SUBDIRS}; do test -f $$subdir/tmp_test.tar && tar -tf $$subdir/tmp_test.tar 2>/dev/null | grep -qv '/$$' && echo "$$subdir already built, skip" || $(MAKE) -C $$subdir -f Makefile || { bash ./common.sh -r; exit 1; }; done
clean:
	bash ./common.sh -r all
