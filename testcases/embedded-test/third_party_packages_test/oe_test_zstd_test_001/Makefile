.PHONY: all
all:
	sh ../common.sh -d "zstd" "${DOWNLOAD_BRANCH}"	
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'zstd-*'`)
	sh ./compile.sh "$(SRC_PATH)"
	cp -r $(SRC_PATH)/programs $(SRC_PATH)/tests ./tmp_test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
