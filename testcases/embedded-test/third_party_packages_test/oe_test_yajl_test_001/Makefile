.PHONY: all
all:
	yum install -y cmake
	sh ../common.sh -d yajl "${DOWNLOAD_BRANCH}" "./yajl/*.tar.gz"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'yajl-*'`)
	sh ./compile.sh "$(SRC_PATH)"
	cp -r $(SRC_PATH)/build $(SRC_PATH)/test ./tmp_test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
