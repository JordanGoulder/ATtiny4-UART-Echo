#include <avr/io.h>

#define BIT_CNT     r18
#define DELAY_CNT   r19
#define DELAY_TICKS r24
#define TX_CHAR     r24
#define RX_CHAR     r24

.comm half_bit_delay, 1

/******************************************************************************/

uart_delay:

    lds DELAY_CNT, half_bit_delay

    uart_delay_loop:
        dec DELAY_CNT
        brne uart_delay_loop

    ret

/******************************************************************************/

.global uart_init
.type uart_init, @function

uart_init:

    lds DELAY_TICKS, half_bit_delay

    sbi PORTB, PORTB0
    sbi DDRB, DDB0

    cbi DDRB, DDB1
    sbi PORTB, PORTB1

    ret

/******************************************************************************/

.global uart_getchar
.type uart_init, @function


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

.global uart_putchar
.type uart_init, @function
uart_putchar:
    ldi BIT_CNT, 11
    com TX_CHAR
    sec

    putchar_next_bit:
        brcc putchar_send_1

        putchar_send_0:
            cbi PORTB, PORTB0
            rjmp putchar_delay

        putchar_send_1:
            sbi PORTB, PORTB0
            nop

        putchar_delay:
            rcall uart_delay
            rcall uart_delay

        lsr TX_CHAR
        dec BIT_CNT

        brne putchar_next_bit

    ret
