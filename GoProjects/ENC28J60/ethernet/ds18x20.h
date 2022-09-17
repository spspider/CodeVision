/* описания для поддержки датчиков DS18x20
 /

#ifndef DS18X20_H_
#define DS18X20_H_

// команды датчиков
#define CMD_START_CONV		0x44
#define CMD_RD_SCRPAD		0xbe
#define CMD_WR_SCRPAD		0x4e
#define CMD_CPY_SCRPAD		0x48
#define CMD_RECALL			0xb8
#define CMD_RD_PSU			0xb4

#endif /* DS18X20_H_ */
