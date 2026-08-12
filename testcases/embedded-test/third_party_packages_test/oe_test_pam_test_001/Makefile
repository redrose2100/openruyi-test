all:
	bash ../common.sh -M "pam" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	tar -xf $$(find ./tmp_download -name "*.tar.xz") -C ./tmp_extract/ || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/Linux-PAM*/ && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/Linux-PAM*/ && make -C tests check-am || true
	cd ./tmp_extract/Linux-PAM*/tests && \
	rm -rf *.log && \
	rm -rf *.trs
	bash ../common.sh -c "Linux-PAM*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "Linux-PAM*" "test-driver" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cp ./tmp_extract/Linux-PAM*/tests/.libs/tst-* ./tmp_test/tests/ || true
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
