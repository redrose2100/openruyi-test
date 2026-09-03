all:
	bash ../common.sh -M "procps-ng" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	if [ -e ./tmp_download/procps-ng/backport-vmstat-Print-guest-time.patch ]; then \
	patch -p1 -d ./tmp_extract/procps*/ < ./tmp_download/procps-ng/backport-vmstat-Print-guest-time.patch; \
	fi || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/procps* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && make src/tests/test_strutils src/tests/test_fileutils src/tests/test_shm src/tests/test_process || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/procps* && \
	make -C testsuite site.exp
	bash ../common.sh -c "procps*" "testsuite" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "procps*" "ps" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "procps*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	mkdir -p tmp_test/tests && \
	cp ./tmp_extract/procps*/src/tests/test_fileutils ./tmp_extract/procps*/src/tests/test_strutils ./tmp_extract/procps*/src/tests/test_shm ./tmp_extract/procps*/src/tests/test_process tmp_test/tests/ || true
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
