TARGET   = uart-echo

MCU      = attiny4
FREQ     = 1000000

C_SRCS   = main.c
AS_SRCS  = uart.S
C_OBJS   = $(C_SRCS:.c=.o) 
AS_OBJS  = $(AS_SRCS:.S=.o)
_OBJECTS = $(C_OBJS) $(AS_OBJS)
OBJECTS  = $(patsubst %,build/%,$(_OBJECTS))
DEPS     = $(OBJECTS:.o=.d)

CROSS    = avr
CC       = $(CROSS)-gcc
AS       = $(CROSS)-gcc
SIZE     = $(CROSS)-size
OBJCOPY  = $(CROSS)-objcopy

CFLAGS   = -Wall
CFLAGS  += -Os
CFLAGS  += -mmcu=$(MCU) -DF_CPU=$(FREQ)
CFLAGS  += -ffunction-sections -fdata-sections

ASFLAGS += $(CFLAGS)

LDFLAGS  = -Wl,-Map,build/$(TARGET).map
LDFLAGS += -Wl,--gc-sections

all: build/$(TARGET).hex

-include $(DEPS)

build/%.o : %.S
	@mkdir -p build
	$(CC) $(ASFLAGS) $(CPPFLAGS) -c -MM -MF $(patsubst %.o,%.d,$@) $<
	@sed -i 's/.*\.o/build\/&/' $(patsubst %.o,%.d,$@)
	$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

build/%.o : %.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -MM -MF $(patsubst %.o,%.d,$@) $<
	@sed -i 's/.*\.o/build\/&/' $(patsubst %.o,%.d,$@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

build/$(TARGET).elf : $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

build/$(TARGET).hex : build/$(TARGET).elf
	$(SIZE) -C --mcu=$(MCU) $^
	$(OBJCOPY) -O ihex -j .text $^ $@ 

.PHONY: clean
clean:
	@rm -f build/$(TARGET).{hex,elf,map} $(OBJECTS) $(DEPS)
	@rmdir build
