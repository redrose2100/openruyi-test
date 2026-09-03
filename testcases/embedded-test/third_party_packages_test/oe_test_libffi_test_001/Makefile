all:
	bash ../common.sh -M "libffi" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libffi* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --disable-builddir || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ./compile_all_test.sh || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libffi*" "libffi.bhaible" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libffi*" "testsuite_out" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
