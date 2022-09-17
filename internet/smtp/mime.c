#include "mime.h"

char base64_enc(uint8_t val)
{
	val &= 0x3f;
	if(val <= 25) return val + 'A';
	if(val <= 51) return val + 'a' - 26;
	if(val <= 61) return val + '0' - 52;
	if(val == 62) return '+';
	return '/';
}

uint8_t base64_encode(char *buf, uint8_t *data, uint8_t len)
{
	uint8_t outlen = 0;
	uint32_t val;
	uint8_t *p;

	while(len)
	{
		p = (uint8_t*)&val + 3;
		*(--p) = *(data++);
		*(--p) = *(data++);
		*(--p) = *(data++);

		*(buf++) = base64_enc(val>>18);
		*(buf++) = base64_enc(val>>12);
		len--;

		if(len) {
			*(buf++) = base64_enc(val>>6);
			len--;
		} else {
			*(buf++) = '=';
		}

		if(len) {
			*(buf++) = base64_enc(val);
			len--;
		} else {
			*(buf++) = '=';
		}

		outlen += 4;
	}

	return outlen;
}
