class_name MagicOffSwitch
extends Node2D

@onready var check_button: CheckButton = $CheckButton
@onready var on_sound: AudioStreamPlayer = $OnSound
@onready var off_sound: AudioStreamPlayer = $OffSound
@onready var finger_point: Sprite2D = $FingerPoint
@onready var auto_toggle_timer: Timer = Timer.new()

var _resource: UpgradeStats;
var _init_position: Vector2;
var touchingButtonPoint: Vector2

var current_steps := 0
const TOTAL_STEPS := 10  # number of steps before contact
var step_distance := 0.0

var toggle_on := false;

func attach_resource(resource: UpgradeStats) -> void:
	_resource = resource

# There are certains steps to be met before this is considered "clicked"
func fire_step() -> void:
	pass;

func _ready() -> void:
	check_button.focus_mode = Control.FOCUS_NONE
	_init_position = finger_point.position
	touchingButtonPoint = finger_point.position
	finger_point.position.x -= 50
	step_distance = (touchingButtonPoint.x - finger_point.position.x) / TOTAL_STEPS
	
	# Timer setup
	auto_toggle_timer.wait_time = 1
	auto_toggle_timer.one_shot = false
	auto_toggle_timer.autostart = true
	add_child(auto_toggle_timer)
	auto_toggle_timer.timeout.connect(_on_auto_toggle_timer_timeout)

func _push_finger() -> void:
	if current_steps < TOTAL_STEPS:
		current_steps += 1
		# Phase 1: move finger toward button
		finger_point.position.x += step_distance
		
		if current_steps == TOTAL_STEPS:
			toggle_on = true;
			SignalBus.MagicSwitchToggled.emit(toggle_on)
			on_sound.play()

func _lift_finger() -> void:
	if current_steps > 0:
		# Phase 1: lift finger away
		finger_point.position.x -= step_distance
		current_steps -= 1
		if toggle_on:
			toggle_on = false;
			SignalBus.MagicSwitchToggled.emit(toggle_on)
			off_sound.play()

# Pressed by user
func _on_check_button_pressed() -> void:
	_lift_finger()
	check_button.button_pressed = toggle_on

# Pressed by timer
func _on_auto_toggle_timer_timeout() -> void:
	if current_steps != TOTAL_STEPS:
		_push_finger()
	
	check_button.button_pressed = toggle_on
