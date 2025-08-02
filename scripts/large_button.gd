@tool
class_name LargeButton
extends Node2D

@onready var top_of_button: Node2D = $TopButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@export_range(0.0, 9, 1)
var press_steps: float = 9;

var pressed_called := false;

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update_button_position()

func pressStep() -> void:
	press_steps = clamp(press_steps - 1, 0, 9)
	_update_button_position()

func releaseStep() -> void:
	press_steps = clamp(press_steps + 1, 0, 9)
	_update_button_position()

func _update_button_position() -> void:
	top_of_button.position.y = -press_steps;
	if press_steps == 0:
		_on_button_pressed();
	else:
		pressed_called = false;

func _on_button_pressed() -> void:
	if pressed_called:
		return;
	pressed_called = true;
	audio_stream_player.play()
