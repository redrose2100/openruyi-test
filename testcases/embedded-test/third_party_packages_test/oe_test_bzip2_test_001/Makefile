all:
	sh ../common.sh -d "bzip2" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/bzip2* && \
	make
	sh ../common.sh -c "bzip2*" "sample*.ref"
	sh ../common.sh -c "bzip2*" "sample*.bz2"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"



