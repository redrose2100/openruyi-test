all:
	bash ../common.sh -M "bzip2" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	( cd ./tmp_extract/bzip2* && \
	make CC="$${CROSS_COMPILE}gcc" CFLAGS="-Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64 -fPIC" libbz2.a bzip2 bzip2recover ) || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "bzip2*" "sample*.ref" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "bzip2*" "sample*.bz2" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"


