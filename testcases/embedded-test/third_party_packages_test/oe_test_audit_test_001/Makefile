# test_machinetab()删除，由于编译环境和嵌入式镜像不一致
all:
	dnf install -y go || yum install -y go || apt-get install -y golang-go || true
	bash ../common.sh -M "audit" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/audit* && \
	sed -i '/test_machinetab();/d' ./lib/test/lookup_test.c && \
	sed -i 's/SUBDIRS.*bindings/SUBDIRS =/' Makefile.am && \
	sed -i 's/bindings\/python//' Makefile.am && \
	autoreconf -f -i && \
	if command -v go >/dev/null 2>&1; then golang_flag="--with-golang"; else golang_flag="--without-golang"; fi && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)	 \
			--sbindir=/sbin --libdir=/lib64 --without-python --without-python3 \
			--disable-zos-remote $$golang_flag --enable-systemd && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' lib/test/Makefile && \
	sed -i 's/check-local/#check-local/g' auparse/test/Makefile && \
	sed -i 's/check-TESTS/#check-TESTS/g' audisp/plugins/remote/Makefile && \
	sed -i 's/check-TESTS/#check-TESTS/g' src/test/Makefile && \
	make check && \
	mv lib/test lib/lib_tests && \
	mv auparse/test lib/auparse_tests || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "lib_tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "auparse_tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "ilist_test" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "slist_test" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "test-queue" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "audit*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r

clean:
	bash ../common.sh -r "all"
