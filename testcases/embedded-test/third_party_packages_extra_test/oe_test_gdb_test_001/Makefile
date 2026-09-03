.PHONY: all clean
all:
	bash ../common.sh -M "gdb"
	bash ./compile.sh || exit 1
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
