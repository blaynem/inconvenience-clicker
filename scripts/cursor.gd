extends Sprite2D

var shouldSlow = false;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _process(_delta: float) -> void:
	if shouldSlow:
		global_position = lerp(global_position, get_global_mouse_position(), .01)
	else:
		global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		shouldSlow = !shouldSlow
