extends Node
class_name Request

var _title : String = "";
var _requestor : String = "";
var _body : String = "";
var _objectives : Array[String] = [];
var _requirements : Array[Requirement] = [];
var _partyScoreReq : int = 0;

var _goldReward : int = 0;

# Timers
var TIMER_travel_to : String;
var TIMER_mission_duration : String;
var TIMER_travel_home : String;
