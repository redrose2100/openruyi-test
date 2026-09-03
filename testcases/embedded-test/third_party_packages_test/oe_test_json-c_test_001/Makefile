all:
	dnf install -y cmake || yum install -y cmake || apt-get install -y cmake || true
	bash ../common.sh -M "json-c" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	mkdir -p ./tmp_extract/build || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	cd ./tmp_extract/build && \
	cmake ../json-c*/ -DBUILD_STATIC_LIBS=OFF && \
	make || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "build" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "json-c*" "tests" || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	rm -rf ./tmp_test/tests/CMakeFiles || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	rm -rf ./tmp_test/tests/Makefile || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	rm -rf ./tmp_test/tests/*.cmake || { cd $(CURDIR) && bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
