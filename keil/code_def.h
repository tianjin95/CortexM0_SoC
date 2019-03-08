#include <stdint.h>

//INTERRUPT DEF
#define NVIC_CTRL_ADDR (*(volatile unsigned *)0xe000e100)

//WATERLIGHT DEF
typedef struct{
    volatile uint32_t Waterlight_MODE;
    volatile uint32_t Waterlight_SPEED; 
}WaterLightType;

#define WaterLight_BASE 0x40000000
#define WaterLight ((WaterLightType *)WaterLight_BASE)

//UART DEF
typedef struct{
    volatile uint32_t UARTRX_DATA;
    volatile uint32_t UARTTX_STATE;
    volatile uint32_t UARTTX_DATA;
}UARTType;

#define UART_BASE 0x40000010
#define UART ((UARTType *)UART_BASE)

//DMAC DEF
typedef struct{
    volatile uint32_t DMA_SRC;
    volatile uint32_t DMA_DST;
    volatile uint32_t DMA_SIZE;
    volatile uint32_t DMA_LEN;
}DMACType;

#define DMAC_BASE 0x40000020
#define DMAC ((DMACType *)DMAC_BASE)

void SetWaterLightMode(int mode);
void SetWaterLightSpeed(int speed);
void Delay(int interval);
char ReadUARTState(void);
char ReadUART(void);
void WriteUART(char data);
void UARTString(char *stri);
void UARTHandle(void);
void DMA(int src,int dst,int size,int len);
