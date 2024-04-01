all:
	sh ../common.sh -d "libfastjson" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libfastjson* && \
	autoreconf -iv && \
	export CFLAGS="$$RPM_OPT_FLAGS -D_GNU_SOURCE -Wl,-z,relro,-z,now -fstack-protector-strong" && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-shared --disable-static && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' tests/Makefile && \
	make V=1 check
	sh ../common.sh -c "libfastjson*" "tests"
	sh ../common.sh -c "libfastjson*" "test-driver"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"