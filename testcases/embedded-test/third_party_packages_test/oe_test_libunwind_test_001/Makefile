all:
	bash ../common.sh -M "libunwind" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libunwind* && \
	aclocal && \
	libtoolize --force && \
	autoheader && \
	automake --add-missing && \
	autoconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-static --enable-shared --enable-setjmp=no && \
	make -O -j1 V=1 VERBOSE=1 || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libunwind* && \
	make check > tmpfile 2>&1 || true && \
	grep "FAIL: [a-zA-Z]" tmpfile | awk '{print $$2}' > testfile || true && \
	touch testfile
	bash ../common.sh -c "libunwind*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libunwind*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libunwind*" "testfile" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
