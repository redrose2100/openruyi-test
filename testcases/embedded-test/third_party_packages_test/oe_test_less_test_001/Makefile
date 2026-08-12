SHELL=/bin/bash
all:
	bash ../common.sh -M "less" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/less-661/lesstest && \
	sed -i "s/CC =/# CC =/g" Makefile && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp -Rr ./tmp_extract/less-661/lesstest ./tmp_test/ || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
