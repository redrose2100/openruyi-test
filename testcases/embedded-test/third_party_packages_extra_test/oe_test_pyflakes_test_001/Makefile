.PHONY: all
all:
	bash ../common.sh -M "pyflakes"
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'pyflakes-*'`)
	cp -fr $(SRC_PATH)/pyflakes/test/ ./tmp_test/
	sh ../common.sh -r


.PHONY: clean
clean:
	sh ../common.sh -r "all"
