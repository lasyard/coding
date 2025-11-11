# define this to turn on debug
DEBUG ?= y

CUDA_PATH := /usr/local/cuda-12.6
CUDA_FLAGS := -I$(CUDA_PATH)/include -L$(CUDA_PATH)/lib64 -lnvptxcompiler_static -lcuda -lm

CFLAGS += -pipe -Wall

ifeq ($(DEBUG), y)
  CFLAGS += -g -O -DDEBUG
else
  CFLAGS += -O2
endif

DEPFILE := .depend

.PHONY: all clean

all: driver_api_test $(DEPFILE)

driver_api_test: driver_api_test.c
	$(CC) $(CFLAGS) -o $@ $^ $(CUDA_FLAGS)

$(DEPFILE): driver_api_test.c
	$(CC) $(CFLAGS) -MM driver_api_test.c > $(DEPFILE)

clean:
	-rm -f *.o
	-rm -f driver_api_test
	-rm -f $(DEPFILE)

ifeq ($(DEPFILE), $(wildcard $(DEPFILE)))
  include $(DEPFILE)
endif
