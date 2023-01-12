  TARGET = function_transmission_006
OBJECTS = softbus_function_transmission_006.o

LIBS = -lsoftbus_client.z -lsyspara.z -ldeviceauth_sdk.z -lsec_shared.z -lsoftbus_utils.z
CFLAGS=-Wall

.PHNOY:all
all: ${TARGET}
obj: ${OBJECTS}

${TARGET} : ${OBJECTS} Makefile
	${CC} -o ${TARGET} ${OBJECTS} ${LIBS}
%.o: %.c
	${CC} ${CFLAGS} -c $< 
.PHNOY: clean
clean:
	-rm -rf ${TARGET} ${OBJECTS}