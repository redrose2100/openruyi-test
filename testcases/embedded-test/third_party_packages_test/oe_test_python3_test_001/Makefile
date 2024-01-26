.PHONY: all clean
all:
	sh ../common.sh -d "python3" "${DOWNLOAD_BRANCH}" "python3/Python*.tar.xz" "tar"
	sh ./compile.sh
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
