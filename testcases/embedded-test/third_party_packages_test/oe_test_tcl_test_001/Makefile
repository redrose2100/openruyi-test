.PHONY: all clean
all:
	bash ../common.sh -M "tcl" || { bash ../common.sh -r; exit 1; }
	bash ./compile.sh || { bash ../common.sh -r; exit 1; }
	bash ../common.sh -r
clean:
	bash ../common.sh -r "all"
