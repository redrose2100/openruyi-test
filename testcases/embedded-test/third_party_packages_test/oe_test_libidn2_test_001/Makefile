all:
	bash ../common.sh -M "libidn2" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	dnf -y install texinfo || yum -y install texinfo || apt-get install -y texinfo || true
	cd ./tmp_extract/libidn2* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --disable-static && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' tests/Makefile && \
	make -j1 -C tests check || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libidn2*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libidn2*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
