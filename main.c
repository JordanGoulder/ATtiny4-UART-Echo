#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>

#include "uart.h"

int main(void)
{
    uart_init(14);

    while (1) {
        uint8_t c = uart_getchar();
        uart_putchar(c);
    }

    return 0;
}

