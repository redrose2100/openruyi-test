COMMON_LIB := libsoftbus_common.a
COMMON_OBJ = dsoftbus_common.o

.PHNOY:all
all: ${COMMON_LIB}

${COMMON_LIB}: ${COMMON_OBJ}
	${AR} rcs ${COMMON_LIB} $^

%.o: %.c
	${CC} ${CFLAGS} -c $<

clean:
	-rm -rf ${COMMON_LIB} ${COMMON_OBJ}