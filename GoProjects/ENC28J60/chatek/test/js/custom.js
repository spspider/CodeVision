/*
 * LED control
 */

function led_state(state) 
{
	switch(state) {
		case '0':
			$("#led-on").show();
			$("#led-off").hide();
			break;
		case '1':
			$("#led-off").show();
			$("#led-on").hide();
			break;
	}
}

function led_update() {
	$.get("/cgi-bin/led/state/", null, led_state);
	window.setTimeout(led_update, 30000);
}

function led_init()
{
	$("#led-on").click(function() {
		$.get("/cgi-bin/led/on/", null, led_state);
	});
	$("#led-off").click(function() {
		$.get("/cgi-bin/led/off/", null, led_state);
	});
	led_update();
}

/*
 * DS1820
 */

function ds1820_update()
{
	$.get("/cgi-bin/ds1820/value/", null, function(val) {
		$("#ds1820-value").html(/*"T="+*/val+"&deg;");
	});
	window.setTimeout(ds1820_update, 30000);
}

/*
 * Chat
 */

var chat_id=0;
var chat_nickname = "";

function chat_data(data)
{
	arr = data.split("\r\n");
	
	for(var key in arr)
	{
		if( (row = arr[key].match(/^(\d+):(.+)$/)) &&
            (row.length == 3) )
		{
			cur_id = parseInt(row[1]);

			if(cur_id >= chat_id)
			{
				chat_id = cur_id+1;
				obj = $("#chat-text");
				obj[0].value += row[2] + "\r\n";
				obj.scrollTop(obj[0].scrollHeight);
			}
		}
	}
}

function chat_update()
{
	$.get("/cgi-bin/chat/load/", null, chat_data);
	setTimeout(chat_update, 2000);
}

function chat_change_nick(nick)
{
	if( (nick.length < 2) || 
		(nick.length > 10) ||
		(nick == "%username%") ) 
	{
		window.alert("Очень плохой ник :(");
        return false;
	}
	chat_nickname = nick;
    return true;
}

function chat_init()
{
	$("#chat-say").keypress(function(e) {
		if(e.keyCode == 13) {
			msg = $("#chat-say").val();
			
			if( (arr = msg.match(/^\/(\w+)(\s+(.+))?$/)) &&
                (arr.length == 4) ) 
            {
				switch(arr[1])
				{
                case "clear":
                case "c":
					$("#chat-text").val("");
                    $("#chat-say").val("");
					break;
                case "name":
                case "nick":
                    if(chat_change_nick(arr[3]))
                        $("#chat-text")[0].value += "Name changed to " + chat_nickname + "\r\n";
                    $("#chat-say").val("");
                    break;
				}
			} else if((msg.length > 0) && (msg.length < 32)) {
				if(chat_nickname == "") {
					chat_change_nick(window.prompt("Твой ник? :)", "%username%"));
				}
				if(chat_nickname != "") {
					$("#chat-say").val("");
					str = chat_nickname + ": " + msg;
					$.get("/cgi-bin/chat/say/", {msg: str}, chat_data);
				}
			}
		}
	});

	$("#chat-say").focus();
	$("#chat-text").val(
        "-----------------------------\r\n" +
        "Преведствую тя в чятике!\r\n" +
        "/name (имя) - установить ник\r\n" +
        "/clear - очистить лог\r\n" +
        "-----------------------------\r\n");
	chat_update();
}

/*
 * Misc.
 */

if(navigator.appName == "Microsoft Internet Explorer")
    window.location = "http://lleo.aha.ru/na/";

$(document).ready(function() {
	led_init();
	ds1820_update();
	chat_init();
});
