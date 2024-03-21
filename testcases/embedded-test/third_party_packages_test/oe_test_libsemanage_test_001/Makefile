.PHONY: all clean
all:
	sh ../common.sh -d "libsemanage" "${DOWNLOAD_BRANCH}"
	sh  -x ../common.sh -d "CUnit" "${DOWNLOAD_BRANCH}"  "CUnit/cunit*.tar.bz2" "tar"
	sh ./compile.sh
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
