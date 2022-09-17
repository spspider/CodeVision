#
#	Makefile for CDC-IO demo program
#
#	Osamu Tamura @ Recursion Co., Ltd.
#
#	http://www.recursion.jp/avrcdc/
#

TARGET=iodemo
SRCS=$(TARGET).c
OBJS=$(TARGET).o

CFLAGS=-g -pipe -Wall
LDLIBS=-lm -lwrap  # if linux, add '-lnsl'

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
	mv $(TARGET) /usr/bin

clean:
	rm -f $(OBJS) $(TARGET) $(.CURDIR)/errs

