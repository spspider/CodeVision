<?php
	header("Pragma: no-cache");
	header("Cache-control: no-cache");
	fwrite(fopen("../state.txt", "w"), "1");
	echo("1");