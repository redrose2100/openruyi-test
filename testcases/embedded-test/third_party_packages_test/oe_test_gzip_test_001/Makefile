all:
	bash ../common.sh -M "gzip" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/gzip*  && \
	autoreconf && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make -O -j1 V=1 VERBOSE=1 || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "gzip*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "gzip*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
