all:
	sh ../common.sh -d "libidn2" "${DOWNLOAD_BRANCH}"
	dnf -y install texinfo
	cd ./tmp_extract/libidn2* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --disable-static && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' tests/Makefile && \
	make -j1 -C tests check
	sh ../common.sh -c "libidn2*" "test-driver"
	sh ../common.sh -c "libidn2*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"