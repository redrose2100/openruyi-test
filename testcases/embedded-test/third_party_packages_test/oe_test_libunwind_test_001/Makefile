all:
	sh ../common.sh -d "libunwind" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libunwind* && \
	aclocal && \
	libtoolize --force && \
	autoheader && \
	automake --add-missing && \
	autoconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-static --enable-shared --enable-setjmp=no && \
	make -O -j1 V=1 VERBOSE=1 && \
	rm -rf src/.libs/libunwind*.so* && \
	cp -r $${SDKTARGETSYSROOT}/usr/lib64/libunwind*.so** src/.libs && \
	make check 2>&1 > tmpfile || true && \
	grep "FAIL: [a-zA-Z]" tmpfile | awk '{print $$2}' > testfile
	sh ../common.sh -c "libunwind*" "test-driver"
	sh ../common.sh -c "libunwind*" "tests"
	sh ../common.sh -c "libunwind*" "testfile"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"