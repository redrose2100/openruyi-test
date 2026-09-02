.PHONY: all
all:
	bash ../common.sh -M "pyparsing"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'pyparsing-*'`)
	cp -r $(SRC_PATH)/tests ./tmp_test/
	bash ../common.sh -r


.PHONY: clean
clean:
	bash ../common.sh -r "all"
