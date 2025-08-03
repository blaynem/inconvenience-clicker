class_name DoubleFingerButton
extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var finger_point: Sprite2D = $FingerPoint
@onready var large_button: LargeButton = $LargeButton
@onready var large_button_2: LargeButton = $LargeButton2
@onready var marker_2d: Marker2D = $Marker2D

var _resource: UpgradeStats;
var _init_position: Vector2;
var touchingButtonPoint: Vector2

var current_steps := 0
const PHASE1_STEPS := 10  # number of steps before contact
var step_distance := 0.0

var score_added := false;

func attach_resource(resource: UpgradeStats) -> void:
	_resource = resource

# There are certains steps to be met before this is considered "clicked"
func fire_step() -> void:
	if score_added:
		_lift_finger()
	else:
		_push_finger()

func _ready() -> void:
	_init_position = finger_point.position
	touchingButtonPoint = finger_point.position
	finger_point.position.y -= 100
	step_distance = (touchingButtonPoint.y - finger_point.position.y) / PHASE1_STEPS

func _push_finger() -> void:
	if current_steps < PHASE1_STEPS:
		# Phase 1: move finger toward button
		finger_point.position.y += step_distance
	elif large_button.current_step > 0:
		# Phase 2: press the button
		large_button.pressStep()
		large_button_2.pressStep()
		if large_button.pressed_called:
			score_added = true;
			ScoreGainNumber.display_numer(_resource.get_production(), marker_2d.global_position, Vector2(1.3, 1.3))
			audio_stream_player.play()
			SignalBus.AddToScore.emit(_resource)
	# add 1 to current_steps
	current_steps += 1

func _lift_finger() -> void:
	if large_button.current_step < large_button.max_steps:
		# Phase 2: release the button
		large_button.releaseStep()
		large_button_2.releaseStep()
	elif current_steps > 0:
		# Phase 1: lift finger away
		finger_point.position.y -= step_distance
	# Remove 1 from current_step
	if current_steps > 0:
		current_steps -= 1
	else:
		score_added = false;
