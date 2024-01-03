all:
	sh ../common.sh -d "gzip" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/gzip*  && \
	autoreconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make -O -j1 V=1 VERBOSE=1
	sh ../common.sh -c "gzip*" "tests"
	sh ../common.sh -c "gzip*" "test-driver"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
