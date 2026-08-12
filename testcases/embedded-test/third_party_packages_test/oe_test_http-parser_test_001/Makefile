.PHONY: all
all:
	bash ../common.sh -M "http-parser" || { bash ../common.sh -r; exit 1; }
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'http-parser-*'`)
	bash ./compile.sh "$(SRC_PATH)" || { bash ../common.sh -r; exit 1; }
	mkdir -p ./tmp_test/test/ || { bash ../common.sh -r; exit 1; }
	cp -r $(SRC_PATH)/test_g ./tmp_test/test/ && cp -r $(SRC_PATH)/test_fast ./tmp_test/test/ || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -r


.PHONY: clean
clean:
	bash ../common.sh -r "all"
