all:
	sh ../common.sh -d "libunistring" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libunistring* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make -O -j1 V=1 VERBOSE=1 && \
	rm -rf lib/.libs/libunistring.so* && \
	cp -r $${SDKTARGETSYSROOT}/usr/lib64/libunistring.so* lib/.libs && \
	sed -n '/TESTS =/,/\XFAIL_TESTS =/p' tests/Makefile | grep test | awk '{print $$1}' | awk '!/\\/'| awk 'NF > 0' | grep -v "TESTS" > testfile && \
	sed -n '/TESTS =/,/\XFAIL_TESTS =/p' tests/Makefile | grep test | awk '{print $$2}' | awk '!/\\/'| awk 'NF > 0' | grep -v "=" >> testfile && \
	sed -n '/TESTS =/,/\XFAIL_TESTS =/p' tests/Makefile | grep test | awk '{print $$3}' | awk '!/\\/'| awk 'NF > 0' >> testfile && \
	make check || true && \
	sed -i 's/\$$(EXEEXT)//g' testfile && \
	sed -i 's/\$$(am__EXEEXT_1)/test-categ_none/g' testfile && \
	sed -i 's/\$$(am__append_50)/uniname\/test-uninames.sh/g' testfile 
	sh ../common.sh -c "libunistring*" "test-driver"
	sh ../common.sh -c "libunistring*" "tests"
	sh ../common.sh -c "libunistring*" "testfile"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"