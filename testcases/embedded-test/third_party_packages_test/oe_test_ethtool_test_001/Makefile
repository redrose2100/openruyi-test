all:
	sh ../common.sh -d "ethtool" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/ethtool* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make test-cmdline 
	sh ../common.sh -c "ethtool*" "test-cmdline"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"

	



