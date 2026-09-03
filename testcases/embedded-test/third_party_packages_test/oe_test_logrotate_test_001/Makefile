all:
	bash ../common.sh -M "logrotate" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "logrotate*" "test" || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -c "logrotate*" "test-driver" || { bash ../common.sh -r; exit 1; }
	cp -f ./tmp_test/test-driver ./tmp_test/test/ || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"