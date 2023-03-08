targets:=${shell ls *.c | sed 's/\.c//g'}

default:
	@for i in ${targets}; do gcc $$i.c -o $$i -lrt; done

clean:
	@for i in ${targets}; do rm -rf $$i; done
