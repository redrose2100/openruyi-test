.PHONY: all
all:
	sh ../common.sh -d "lzo" "${DOWNLOAD_BRANCH}"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'lzo-*'`)
	sh ./compile.sh "$(SRC_PATH)"
	mkdir -p ./tmp_test/test/
	cp -r $(SRC_PATH)/* ./tmp_test/test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
