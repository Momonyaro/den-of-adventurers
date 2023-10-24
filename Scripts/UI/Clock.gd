extends Label

func _process(_delta):
	var dateDict = Time.get_datetime_dict_from_system();
	self.text = str(_title_case(_weekday_to_string(dateDict.weekday)).substr(0, 3), " ", dateDict.hour, ":", _format_minute(dateDict.minute));

func _title_case(value: String):
	return value[0].to_upper() + value.substr(1).to_lower();

func _weekday_to_string(value: int):
	match(value):
		1: return "Monday";
		2: return "Tuesday";
		3: return "Wednesday";
		4: return "Thursday";
		5: return "Friday";
		6: return "Saturday";
		_: return "Sunday";

func _format_minute(minute: int):
	return str(0, minute) if minute < 10 else str(minute);
