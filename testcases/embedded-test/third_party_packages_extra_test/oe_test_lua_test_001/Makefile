all:
	sh ../common.sh -g "lua" "${DOWNLOAD_BRANCH}"
	tar -xf ./tmp_download/lua/lua-*-tests.tar.gz -C ./tmp_extract/
	sh ../common.sh -c "./" "lua-*-tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"




