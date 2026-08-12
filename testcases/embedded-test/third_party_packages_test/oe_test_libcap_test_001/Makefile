all:
	bash ../common.sh -M "libcap" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/libcap* && \
	sed -i 's/CC := $$(CROSS_COMPILE)gcc/CC := $$(CC)/g' ./Make.Rules && \
	sed -i 's/--static/ /g' ./pam_cap/Makefile && \
	sed -i 's|./lazylink.so.*echo "-lpam"|echo "-lpam"|g' ./pam_cap/Makefile && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes all && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C libcap cap_test && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C tests psx_test libcap_psx_test && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C pam_cap test_pam_cap || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libcap*" "cap_test" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libcap*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "libcap*" "test_pam_cap" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
