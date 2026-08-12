all:
	bash ../common.sh -M "e2fsprogs" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/e2fsprogs* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-elf-shlibs --disable-libuuid --disable-uuidd --disable-libblkid --enable-verbose-makecmds --with-crond-dir=no && \
	make && \
	cd tests && \
	make test_one && \
	make test_script && \
	cd .. && \
	rm -rf ./debian ./lib || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "e2fsprogs*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp -f ./test_config ./tmp_test/tests/ || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
