.PHONY: all
all:
	sh ../common.sh -d "http-parser" "${DOWNLOAD_BRANCH}"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'http-parser-*'`)
	sh ./compile.sh "$(SRC_PATH)"
	mkdir -p ./tmp_test/test/
	cp -r $(SRC_PATH)/{test_g,test_fast} ./tmp_test/test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
