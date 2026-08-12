all:
	bash ../common.sh -M "libfastjson" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libfastjson* && \
	autoreconf -iv && \
	export CFLAGS="$$RPM_OPT_FLAGS -D_GNU_SOURCE -Wl,-z,relro,-z,now -fstack-protector-strong" && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-shared --disable-static && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' tests/Makefile && \
	make V=1 check || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libfastjson*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libfastjson*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
