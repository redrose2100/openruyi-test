all:
	sh ../common.sh -d "findutils" "${DOWNLOAD_BRANCH}"
	dnf -y install gettext-devel gettext
	cd ./tmp_extract/findutils* && \
	autoreconf -fiv && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' lib/Makefile && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' gnulib-tests/Makefile && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' Makefile && \
	cd gnulib-tests/ && \
	make check && \
	cd ../ && \
	make check || true
	sh ../common.sh -c "findutils*" "check-regexprops"
	sh ../common.sh -c "findutils*" "regexprops"
	sh ../common.sh -c "findutils*" "regexprops.texi"
	sh ../common.sh -c "findutils*" "test_splitstring"
	sh ../common.sh -c "findutils*" "gnulib-tests"
	sh ../common.sh -c "findutils*" "tests"
	sh ../common.sh -c "findutils*" "find"
	sh ../common.sh -c "findutils*" "locate"
	sh ../common.sh -c "findutils*" "xargs"
	sh ../common.sh -c "findutils*" "test-driver"
	sh ../common.sh -c "findutils*" "init.cfg"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"