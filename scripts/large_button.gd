@tool
class_name LargeButton
extends Node2D

@onready var top_of_button: Node2D = $TopButton

const MAX_PX_DISTANCE = 9;
@export_range(0.0, 10, 1)
var max_steps: float = 10:
	set(val):
		max_steps = val;
		current_step = val;

@export var current_step := 10;

var pressed_called := false;

func _ready() -> void:
	current_step = max_steps

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update_button_position()

func pressStep() -> void:
	current_step = clamp(current_step - 1, 0, max_steps)
	_update_button_position()

func releaseStep() -> void:
	current_step = clamp(current_step + 1, 0, max_steps)
	_update_button_position()

func _update_button_position() -> void:
	var percent := current_step / max_steps
	top_of_button.position.y = -percent * MAX_PX_DISTANCE
	
	if current_step == 0:
		_on_button_pressed()
	else:
		pressed_called = false

func _on_button_pressed() -> void:
	if pressed_called:
		return;
	pressed_called = true;
