#include <avr/io.h>

#include "uart_baud.h"

#define BIT_CNT     r18
#define DELAY_CNT   r19
#define DELAY_TICKS r24
#define TX_CHAR     r24
#define RX_CHAR     r24

/******************************************************************************/

.section .text.uart_delay
uart_delay:

    ldi DELAY_CNT, BAUD_SETTING

    uart_delay_loop:
        dec DELAY_CNT
        brne uart_delay_loop

    ret

/******************************************************************************/

.section .text.uart_init
.global uart_init
.type uart_init, @function

uart_init:
    sbi PORTB, PORTB0
    sbi DDRB, DDB0

    cbi DDRB, DDB1
    sbi PORTB, PORTB1

    ret

/******************************************************************************/

.section .text.uart_getchar
.global uart_getchar
.type uart_getchar, @function

uart_getchar:
    ldi BIT_CNT, 9

    wait_for_start:
        sbic PINB, PORTB1
        rjmp wait_for_start

    rcall uart_delay

    getchar_next_bit:
        rcall uart_delay
        rcall uart_delay

        clc
        sbic PINB, PORTB1
        sec

        dec BIT_CNT
        breq getchar_done

        ror RX_CHAR
        rjmp getchar_next_bit

getchar_done:
    ret

/******************************************************************************/

.section .text.uart_putchar
.global uart_putchar
.type uart_putchar, @function

uart_putchar:
    ldi BIT_CNT, 10
    com TX_CHAR
    sec

    putchar_next_bit:
        brcc putchar_send_0

        putchar_send_1:
            cbi PORTB, PORTB0
            rjmp putchar_delay

        putchar_send_0:
            sbi PORTB, PORTB0
            nop

        putchar_delay:
            rcall uart_delay
            rcall uart_delay

        lsr TX_CHAR

        dec BIT_CNT

        brne putchar_next_bit

    ret
