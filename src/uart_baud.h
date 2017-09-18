#define BAUD_RATE (9600)

#define BAUD_SETTING ((((((F_CPU * 10) / (BAUD_RATE)) - 230) / 6) + 5) / 10)

#if BAUD_SETTING > 255
#error BAUD_RATE too slow for F_CPU
#endif

