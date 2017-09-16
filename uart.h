#ifndef UART_H
#define UART_H

#include <stdint.h>

void    uart_init(uint8_t baud);
uint8_t uart_getchar(void);
void    uart_putchar(uint8_t c);

#endif // UART_H
