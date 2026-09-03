all:
	bash ../common.sh -M "popt" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/popt* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/popt*/tests && \
	make check || echo "done"
	bash ../common.sh -c "popt*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
