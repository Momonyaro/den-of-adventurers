extends Label

func _process(_delta):
	var dateDict = Time.get_datetime_dict_from_system();
	self.text = str(_title_case(_weekday_to_string(dateDict.weekday)).substr(0, 3), " ", _format_time(dateDict.hour), ":", _format_time(dateDict.minute));
	self.tooltip_text = _full_time(dateDict);

func _full_time(dateDict) -> String:
	var time = "";
	time += str(_format_time(dateDict.hour), ":", _format_time(dateDict.minute));
	time += str(", ", _title_case(_weekday_to_string(dateDict.weekday)));
	time += str(" the ", dateDict.day, "st" if dateDict.day == 1 else "nd" if dateDict.day == 2 else "rd" if dateDict.day == 3 else "th");
	time += str(" of ", _month_to_string(dateDict.month));
	time += str(" - ", dateDict.year);

	return time;

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

func _month_to_string(value: int):
	match(value):
		1: return "January";
		2: return "Febuary";
		3: return "March";
		4: return "April";
		5: return "May";
		6: return "June";
		7: return "July";
		8: return "August";
		9: return "September";
		10: return "October";
		11: return "November";
		_: return "December";

func _format_time(value: int):
	return str(0, value) if value < 10 else str(value);
