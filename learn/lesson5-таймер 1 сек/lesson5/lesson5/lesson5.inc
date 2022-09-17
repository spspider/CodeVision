
	.DEF _s=R4
_8:
	.DB  0x80,0xC0
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _8*2

	.DW  0
_0x12:
