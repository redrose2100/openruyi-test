all:
	bash ../common.sh -M "dosfstools" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/dosfstools* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "dosfstools*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/dosfstools*/src/mkfs.fat ./tmp_test/tests/mkfs.fat || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/dosfstools*/src/fsck.fat ./tmp_test/tests/fsck.fat || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/dosfstools*/src/fatlabel ./tmp_test/tests/fatlabel || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	bash ../common.sh -M "vim" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/vim* && \
	cd src/xxd/ && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/vim*/src/xxd/xxd ./tmp_test/xxd || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	sed -i 's|\$$RUN "../src/mkfs.fat"|./mkfs.fat|g' ./tmp_test/tests/test-mkfs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i 's|\$$RUN "../src/fsck.fat"|./fsck.fat|g' ./tmp_test/tests/test-mkfs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i 's|\$$RUN "../src/fsck.fat"|./fsck.fat|g' ./tmp_test/tests/test-fsck || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i 's|\$$RUN "../src/fatlabel"|./fatlabel|g' ./tmp_test/tests/test-label || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-fsck || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-label || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-mkfs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-mkfs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-label || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-fsck || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	sed -i 's/cmp $$limitarg/cmp /g' ./tmp_test/tests/test-mkfs || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }

	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
