all:
	bash ../common.sh -M "libtiff" "libtiff/tiff-*"
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
	bash ../common.sh -c "tiff*" "test-driver"
	bash ../common.sh -c "tiff*" "tools"
	bash ../common.sh -c "tiff*" "test"
	bash ../common.sh -c "tiff*" "testfile" 
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"