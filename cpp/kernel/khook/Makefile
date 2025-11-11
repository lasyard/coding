KERNELDIR ?= /lib/modules/$(shell uname -r)/build

obj-m += khook.o

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
