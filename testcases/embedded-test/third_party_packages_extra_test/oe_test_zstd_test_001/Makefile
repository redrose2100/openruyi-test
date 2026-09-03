.PHONY: all
all:
	bash ../common.sh -M "zstd"	
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'zstd-*'`)
	sh ./compile.sh "$(SRC_PATH)"
	cp -r $(SRC_PATH)/programs $(SRC_PATH)/tests ./tmp_test/
	bash ../common.sh -r


.PHONY: clean
clean:
	bash ../common.sh -r "all"
