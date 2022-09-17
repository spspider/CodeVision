#pragma once
#include <avr/io.h>
#include <util/delay.h>
#include "ff/ff.h"
#include "ff/diskio.h"

#define MMC_DDR					DDRB
#define MMC_PORT				PORTB

#define MMC_CS					(1<<PB4)
#define MMC_MOSI				(1<<PB5)
#define MMC_MISO				(1<<PB6)
#define MMC_SCK					(1<<PB7)


#define GO_IDLE_STATE			0
#define SEND_OP_COND			1
#define SEND_IF_COND			8
#define SET_BLOCKLEN			16
#define READ_BLOCK				17
#define WRITE_BLOCK				24
#define APP_CMD					55
#define READ_OCR				58
#define SD_SEND_OP_COND			(0x40|41)


typedef enum card_type_id {
	NO_CARD,
	CARD_MMC,
	CARD_SD,
	CARD_SD2,
	CARD_SDHC
} card_type_id_t;

uint8_t mmc_mount();
