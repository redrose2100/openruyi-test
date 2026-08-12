all:
	bash ../common.sh -M "findutils" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	dnf -y install gettext-devel gettext || yum -y install gettext-devel gettext || apt-get install -y gettext libc6-dev || true
	cd ./tmp_extract/findutils* && \
	autoreconf -fiv || true && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) gl_cv_func_getmntent=yes gl_cv_func_working_getmntent=yes gl_cv_header_mntent_h=yes && \
	make && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' lib/Makefile && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' gnulib-tests/Makefile && \
	sed -i 's/check-TESTS:/#check-TESTS:/g' Makefile && \
	cd gnulib-tests/ && \
	make check && \
	cd ../ && \
	make check || true
	bash ../common.sh -c "findutils*" "check-regexprops" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "regexprops" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "regexprops.texi" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "test_splitstring" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "gnulib-tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "find" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "locate" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "xargs" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "findutils*" "init.cfg" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
