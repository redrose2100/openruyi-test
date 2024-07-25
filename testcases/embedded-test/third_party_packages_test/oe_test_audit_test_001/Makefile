# test_machinetab()删除，由于编译环境和嵌入式镜像不一致
all:
	dnf install -y go
	sh ../common.sh -d "audit" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/audit* && \
	sed -i '/test_machinetab();/d' ./lib/test/lookup_test.c && \
	autoreconf -f -i && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)	 \
			--sbindir=/sbin --libdir=/lib64 --with-python=no \
			--disable-zos-remote --with-golang --enable-systemd && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' lib/test/Makefile && \
	sed -i 's/check-local/#check-local/g' auparse/test/Makefile && \
	sed -i 's/check-TESTS/#check-TESTS/g' audisp/plugins/remote/Makefile && \
	sed -i 's/check-TESTS/#check-TESTS/g' src/test/Makefile && \
	make check && \
	./lib/test/lookup_test || true && \
	./auparse/test/lookup_test || true|| true && \
	mv lib/test lib/lib_tests && \
	mv auparse/test lib/auparse_tests
	sh ../common.sh -c "audit*" "lib_tests"
	sh ../common.sh -c "audit*" "auparse_tests"
	sh ../common.sh -c "audit*" "ilist_test"
	sh ../common.sh -c "audit*" "slist_test"
	sh ../common.sh -c "audit*" "test-queue"
	sh ../common.sh -c "audit*" "test-driver"
	sh ../common.sh -r

clean:
	sh ../common.sh -r "all"

