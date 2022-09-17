<?php
	header("Content-Type: text/plain");
	header("Pragma: no-cache");
	header("Cache-control: no-cache");

	$data = unserialize(file_get_contents("../chat.txt"));

	$id = $data[0];
	$messages = $data[1];
	
	if(($str = $_GET["msg"]))
	{
		$id++;
		
		$messages[] = $str;
		$messages = array_slice($messages, 1, 4);

		fwrite(fopen("../chat.txt", "w"), serialize(array($id, $messages)));
	}
	
	$id_ = $id;
	foreach($messages as $m)
	{
		echo("$id_:$m\r\n");
		$id_++;
	}
	