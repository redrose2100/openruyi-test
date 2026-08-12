.PHONY: all
all:
	dnf install -y cmake || yum install -y cmake || apt-get install -y cmake || true
	bash ../common.sh -M "yajl" || { bash ../common.sh -r; exit 1; }
	$(eval SRC_PATH=`find tmp_extract/ -maxdepth 1 -type d -name 'yajl-*'`)
	bash ./compile.sh "$(SRC_PATH)" || { bash ../common.sh -r; exit 1; }
	cp -r $(SRC_PATH)/build $(SRC_PATH)/test ./tmp_test/ || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -r


.PHONY: clean
clean:
	bash ../common.sh -r "all"
