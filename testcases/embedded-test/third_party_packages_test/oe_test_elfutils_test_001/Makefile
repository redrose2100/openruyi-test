all:
	bash ../common.sh -M "elfutils" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/elfutils* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) \
		--without-bzlib --without-bzip2-replacement-native \
		--without-lzma --without-xz \
		--disable-libdebuginfod --disable-curl \
		--disable-debuginfod --disable-libarchive --disable-sqlite3 --disable-libmicrohttpd \
		--disable-tests-rpath && \
	sed -i 's/$$(MAKE) $$(AM_MAKEFLAGS) check-TESTS/# $$(MAKE) $$(AM_MAKEFLAGS) check-TESTS/g' tests/Makefile && \
	make check && \
	cd tests && \
	sed -i "s/.log: /.log: #/g" Makefile && \
	sed -i "s/check-TESTS: /check-TESTS: #/g" Makefile && \
	sed -i "s/gawk/awk/g" coverage.sh || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "libelf" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "libasm" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "libdw" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "config" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "src" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "elfutils*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
