.PHONY: all clean
all:
	sh -x ../common.sh -d "libcgroup" "${DOWNLOAD_BRANCH}" ''  "zip"
	sh ./compile.sh
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
