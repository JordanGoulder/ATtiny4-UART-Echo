TARGET   = uart-echo

MCU      = attiny4
FREQ     = 1000000

C_SRCS   = main.c
AS_SRCS  = uart.S
C_OBJS   = $(C_SRCS:.c=.o) 
AS_OBJS  = $(AS_SRCS:.S=.o)
OBJECTS  = $(C_OBJS) $(AS_OBJS)
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

LDFLAGS  = -Wl,-Map,$(TARGET).map
LDFLAGS += -Wl,--gc-sections

all: $(TARGET).hex

-include $(DEPS)

%.o : %.S
	$(CC) $(ASFLAGS) $(CPPFLAGS) -c -MM -MF $(patsubst %.o,%.d,$@) $<
	$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -MM -MF $(patsubst %.o,%.d,$@) $<
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(TARGET).elf : $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(TARGET).hex : $(TARGET).elf
	$(SIZE) -C --mcu=$(MCU) $^
	$(OBJCOPY) -O ihex -j .text $^ $@ 

.PHONY: clean
clean:
	@rm -f $(TARGET).{hex,elf,map} $(OBJECTS) $(DEPS)
