#include "mmc.h"

FATFS ff;

card_type_id_t card_type = NO_CARD;

/*
 * MMC/SDC Card functions
 */

// compute checksum for MMC commands
uint8_t mmc_crc7(uint8_t *data, uint8_t len)
{
	uint8_t c, n, crc = 0;

	while(len--)
	{
		c = *(data++);
		for(n = 8; n; --n)
		{
			crc <<= 1;
			if( (c ^ crc) & 0x80 )
				crc ^= 0x09;
			c <<= 1;
		}
	}
	return (crc << 1) | 1;
}

// rxtx byte to MMC card via SPI
uint8_t mmc_send(uint8_t data)
{
	SPDR = data;
	loop_until_bit_is_set(SPSR, SPIF);
	return SPDR;
}

// chip release MMC card
void mmc_release()
{
	MMC_PORT |= MMC_CS;
	mmc_send(0xff);
}

// chip select MMC card
uint8_t mmc_select()
{
	uint16_t timer;

	MMC_PORT &= ~MMC_CS;

	// wait until previous operation completed
	for(timer = 50000; timer; --timer)
	{
		if(mmc_send(0xff) == 0xff)
			return 1;
		_delay_us(20);
	}
	
	mmc_release();
	return 0;
}

// send command frame to MMC card
uint8_t mmc_command(uint8_t code, uint32_t arg)
{
	uint8_t frame[5], crc, n, res;

	// send APP_CMD (for ACMD<n>)
	if(code & 0x40)
	{
		if((res = mmc_command(APP_CMD, 0)) > 1)
			return res; // err
	}

	// send command frame
	frame[0] = code | 0x40;
	frame[1] = arg >> 24;
	frame[2] = arg >> 16;
	frame[3] = arg >> 8;
	frame[4] = arg;
	crc = mmc_crc7(frame, sizeof(frame));
	
	for(n = 0; n < sizeof(frame); ++n)
		mmc_send(frame[n]);
	mmc_send(crc);

	// wait until card respond
	for(n = 10; n; --n)
	{
		if((res = mmc_send(0xff)) != 0xff)
			break;
	}
	
	return res;
}

// initialize MMC card & SPI
uint8_t mmc_init()
{
	card_type_id_t card = NO_CARD;
	uint8_t n, res, ocr[4];
	uint16_t timer;
	
	// setup pins
	MMC_DDR |= MMC_CS|MMC_MOSI|MMC_SCK;
	MMC_DDR &= ~MMC_MISO;
	MMC_PORT |= MMC_CS;
	_delay_ms(20);
	
	// set SPI rate = CLK/64
	SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR1);
	SPSR &= ~(1<<SPI2X);

	// send 80 clocks
	for(n = 10; n; --n)
		mmc_send(0xff);

	if(mmc_select())
	{
		// enter SPI mode
		if(mmc_command(GO_IDLE_STATE, 0) <= 1)
		{

			// set SPI rate = CLK/2
			SPCR = (1<<SPE)|(1<<MSTR);
			SPSR |= (1<<SPI2X);

			// try SEND_IF_COND (for SDCv2 only)
			if(mmc_command(SEND_IF_COND, 0x1aa) <= 1)
			{
				for(n = 0; n < 4; ++n)
					ocr[n] = mmc_send(0xff);

				// check voltage range (1 = 2,7..3,6 v)
				if((ocr[2] == 0x01) && (ocr[3] == 0xaa))
				{

					// wait until card initialized
					for(timer = 50000; timer; --timer)
					{
						// set HCS bit (support SDHC)
						if((res = mmc_command(SD_SEND_OP_COND, 1ul<<30)) != 1)
							break;
						_delay_us(20);
					}

					if(!res)
					{
						// read ocr
						if(!mmc_command(READ_OCR, 0))
						{
							for(n = 0; n < 4; ++n)
								ocr[n] = mmc_send(0xff);

							// check ccs bit (card capacity status)
							if(ocr[0] & 0x40)
								card = CARD_SDHC;
							else
								card = CARD_SD2;
						}
					}
				}
			}
			else
			{
				// try SD_SEND_OP_COND (for SDC only)
				if((res = mmc_command(SD_SEND_OP_COND, 0)) <= 1)
				{
					// wait until card initialized
					for(timer = 50000; timer; --timer)
					{
						if((res = mmc_command(SD_SEND_OP_COND, 0)) != 1)
							break;
						_delay_us(20);
					}

					if(!res)
						card = CARD_SD;
				}

				// card is MMC
				else
				{
					// wait until MMC initialized
					for(timer = 50000; timer; --timer)
					{
						if((res = mmc_command(SEND_OP_COND, 0)) != 1)
							break;
						_delay_us(20);
					}

					if(!res)
						card = CARD_MMC;
				}
			}
		}

		// set r/w block length to 512 bytes (for SDHC is always 512)
		if( (card == CARD_MMC) || (card == CARD_SD) || (card == CARD_SD2) )
			mmc_command(SET_BLOCKLEN, 512);

		mmc_release();
	}

	card_type = card;
	
	return card;
}

// initiate sector read
uint8_t mmc_read_init(uint32_t sector)
{
	uint8_t token;
	uint16_t timer;

	if(card_type != NO_CARD)
	{
		if(mmc_select())
		{
			// SDHC have block addressing
			if(card_type != CARD_SDHC)
				sector <<= 9;

			if(!mmc_command(READ_BLOCK, sector))
			{
				// wait data token
				for(timer = 50000; timer; --timer)
				{
					if((token = mmc_send(0xff)) != 0xff)
						break;
					_delay_us(1);
				}

				if(token == 0xfe)
					return 1;
			}
		
			mmc_release();
		}
	}
	
	return 0;
}

// finish sector read
void mmc_read_final()
{
	// skip crc
	mmc_send(0xff);
	mmc_send(0xff);
	
	mmc_release();
}

// initiate sector read
uint8_t mmc_write_init(uint32_t sector)
{
	if(card_type != NO_CARD)
	{
		if(mmc_select())
		{
			// SDHC addressed by 512-bytes blocks
			if(card_type != CARD_SDHC)
				sector <<= 9;

			if(mmc_command(WRITE_BLOCK, sector))
			{
				// byte space
				mmc_send(0xff);

				// data token
				mmc_send(0xfe);

				return 1;
			}
			
			mmc_release();
		}
	}

	return 0;
}

// finish sector read
uint8_t mmc_write_final()
{
	uint8_t res;

	// dummy crc
	mmc_send(0xff);
	mmc_send(0xff);

	//get data response
	res = mmc_send(0xff);

	mmc_release();

	return ((res & 0x1f) == 0x05);
}


/*
 * FatFs Disk I/O functions
 */

// initialize card
DSTATUS disk_initialize(BYTE drive)
{
	if(!drive)
		return STA_NODISK;
	
	if( (card_type != NO_CARD) || (mmc_init() != NO_CARD) )
		return 0;
	return STA_NOINIT;
}

// check card initialized
DSTATUS disk_status(BYTE drive)
{
	if(!drive)
		return STA_NODISK;
	
	if( card_type != NO_CARD )
		return 0;
	return STA_NODISK;
}

// read sectors from card
DRESULT disk_read(BYTE drive, BYTE *buf, DWORD sector, BYTE count)
{
	uint16_t i;
	
	if( (drive != 0) || (card_type == NO_CARD) )
		return RES_NOTRDY;
	
	while(count--)
	{
		if(!mmc_read_init(sector++))
			return RES_ERROR;
		for(i = 512; i; --i)
			*(buf++) = mmc_send(0xff);
		mmc_read_final();
	}
	return RES_OK;
}

// write sectors on card
DRESULT disk_write(BYTE drive, const BYTE *buf, DWORD sector, BYTE count)
{
	uint16_t i;
	
	if( (drive != 0) || (card_type == NO_CARD) )
		return RES_NOTRDY;
	
	while(count--)
	{
		if(!mmc_write_init(sector++))
			return RES_ERROR;
		
		for(i = 512; i; --i)
			mmc_send(*(buf++));
		
		if(!mmc_write_final())
			return RES_ERROR;
	}
	return RES_OK;
}

// ctrl card
DRESULT disk_ioctl(BYTE drive, BYTE command, void *buf)
{
	if( (drive != 0) || (card_type == NO_CARD) )
		return RES_NOTRDY;
	
	switch(command)
	{
	case CTRL_SYNC:
		if(!mmc_select())
			return RES_ERROR;
		mmc_release();
		return RES_OK;
	}

	return RES_PARERR;
}

DWORD get_fattime()
{
	return 0;
}

/*
 * misc
 */
 
uint8_t mmc_mount()
{
	if(mmc_init())
	{
		f_mount(0, &ff);
		return card_type;
	}
	return NO_CARD;//0
}
