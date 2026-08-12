all:
	bash ../common.sh -M "shadow" || { bash ../common.sh -r; exit 1; }
	mkdir -p tmp_test/tests || { bash ../common.sh -r; exit 1; }
	cp ./run_embedded ./tmp_test/tests/run_embedded || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
