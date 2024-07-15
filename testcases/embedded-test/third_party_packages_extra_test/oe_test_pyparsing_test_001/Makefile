.PHONY: all
all:
	sh ../common.sh -d "pyparsing" "${DOWNLOAD_BRANCH}"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'pyparsing-*'`)
	cp -r $(SRC_PATH)/tests ./tmp_test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
