all:
	bash ../common.sh -M "bash-completion" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/bash-completion*  && \
	autoreconf -fiv && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "bash-completion*" "completions" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"


