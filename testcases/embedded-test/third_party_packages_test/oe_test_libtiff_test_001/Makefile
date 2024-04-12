all:
	sh ../common.sh -d "libtiff" "${DOWNLOAD_BRANCH}" "libtiff/tiff-*"
	dnf -y install libjpeg-turbo-devel libjpeg-turbo-devel
	cd ./tmp_extract/tiff* && \
	libtoolize --force --copy && \
	aclocal -I . -I m4 && \
	automake --add-missing --copy && \
	autoconf && \
	autoheader && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-ld-version-script && \
	make -O -j1 V=1 VERBOSE=1 && \
	make check 2>&1 > tmpfile || true && \
	grep "^FAIL:" tmpfile | awk '{print $$2}' > testfile
	sh ../common.sh -c "tiff*" "test-driver"
	sh ../common.sh -c "tiff*" "tools"
	sh ../common.sh -c "tiff*" "test"
	sh ../common.sh -c "tiff*" "testfile" 
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"