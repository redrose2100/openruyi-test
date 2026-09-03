all:
	bash ../common.sh -M "ethtool" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/ethtool* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make test-cmdline || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "ethtool*" "test-cmdline" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"

	
