all:
	bash ../common.sh -M "zlib" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	( cd ./tmp_extract/zlib* && \
	CHOST=$${CROSS_COMPILE%-} ./configure && \
	make ) || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	mkdir -p tmp_test && ${CC} -Wall -o tmp_test/test test.c -I./tmp_extract/zlib* -L./tmp_extract/zlib* -lz || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r

clean:
	bash ../common.sh -r "all"
