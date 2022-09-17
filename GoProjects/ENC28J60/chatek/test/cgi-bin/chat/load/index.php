<?php
	header("Content-Type: text/plain");
	header("Pragma: no-cache");
	header("Cache-control: no-cache");

	$data = unserialize(file_get_contents("../chat.txt"));

	$id = $data[0];
	$messages = $data[1];

	foreach($messages as $m)
	{
		echo("$id:$m\r\n");
		$id++;
	}
