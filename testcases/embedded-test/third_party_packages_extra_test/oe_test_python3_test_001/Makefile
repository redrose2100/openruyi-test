.PHONY: all clean
all:
	bash ../common.sh -M "python3" "python3/Python*.tar.xz" "tar"
	sh ./compile.sh
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
