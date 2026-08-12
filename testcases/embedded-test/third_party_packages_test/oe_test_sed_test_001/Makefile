all:
	bash ../common.sh -M "sed" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/sed* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine)  \
				--without-included-regex && \
	make -j1 || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "sed*" "testsuite" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "sed*" "init.cfg" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "sed*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"

	
