.PHONY: all clean
all:
	bash ../common.sh -M "python3" "python3/Python*.tar.xz" "tar"
	sh ./compile.sh
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
