#include <util/delay.h>
#include <stdint.h>

#include "uart.h"

int main(void)
{
    uart_init();

    while (1) {
        uint8_t c = uart_getchar();
        uart_putchar(c);
    }

    return 0;
}

