.PHONY: all clean
all:
	sh ../common.sh -d "gawk" "${DOWNLOAD_BRANCH}"
	sh ./compile.sh
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
