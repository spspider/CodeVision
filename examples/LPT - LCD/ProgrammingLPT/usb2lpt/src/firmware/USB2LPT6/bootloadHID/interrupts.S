.extern __init, __vector_5
.global __vector_default, exit
.section .vectors.bootloader

exit:
__vector_default:
	rjmp	__init
	.byte	'b','o','o','t','l','o','a','d'
	rjmp	__vector_5
