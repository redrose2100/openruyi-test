all:
	bash ../common.sh -M "expat" || { bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/expat* && \
	./buildconf.sh && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)	 \
			CFLAGS="$$RPM_OPT_FLAGS -fPIC" DOCBOOK_TO_MAN="xmlto man \
			--skip-validation" && \
	make && \
	sed -i 's/check-TESTS/#check-TESTS/g' tests/Makefile && \
	make check || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "expat*" "runtests" || { bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/expat*/tests/runtests_cxx ./tmp_test/ 2>/dev/null || \
	cp ./tmp_extract/expat*/tests/.libs/runtests_cxx ./tmp_test/ 2>/dev/null || \
	true
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
