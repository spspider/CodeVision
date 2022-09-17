<?php
	header("Pragma: no-cache");
	header("Cache-control: no-cache");
	fwrite(fopen("../state.txt", "w"), "0");
	echo("0");