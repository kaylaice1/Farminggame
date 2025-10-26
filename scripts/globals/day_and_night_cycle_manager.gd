extends Node

const minutes_per_day: int = 24 * 60
const minutes_per_hour: int = 60
const game_minute_duration: float = TAU / minutes_per_day #TAU is short for 2 times PI

var game_speed: float = 5.0

var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

var time: float = 0.0
var current_minute: int = -1
var current_day: int = 0

signal game_time(time: float)
signal time_tick(day: int, hour: int, minute: int)
signal time_tick_day(day: int)

func _ready() -> void:
	set_initial_time()
	
func _process(delta: float) -> void:
	time += delta * game_speed * game_minute_duration
	game_time.emit(time)
	
	recalculate_time()

func set_initial_time() -> void:
	var initial_total_minutes = initial_day * minutes_per_day + (initial_hour * minutes_per_hour) + initial_minute
	
	time = initial_total_minutes * game_minute_duration
	
func recalculate_time() -> void:
	var total_minutes: int = int(time / game_minute_duration)
	var day: int = int(total_minutes / minutes_per_day)
	var current_day_minutes: int = total_minutes % minutes_per_day
	var hour: int = int(current_day_minutes / minutes_per_hour)
	var minute: int = int(current_day_minutes % minutes_per_hour)
	
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day, hour, minute)
		
	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
