all:
	sh ../common.sh -d "expat" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/expat* && \
	autoreconf -fiv && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)	 \
			CFLAGS="$$RPM_OPT_FLAGS -fPIC" DOCBOOK_TO_MAN="xmlto man \
			--skip-validation" && \
	make && \
	sed -i 's/check-TESTS/#check-TESTS/g' tests/Makefile && \
	make check 
	sh ../common.sh -c "expat*" "runtests"
	sh ../common.sh -c "expat*" "runtestspp"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"

