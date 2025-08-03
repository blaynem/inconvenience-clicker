class_name Cursor
extends Sprite2D

# The random select position we want the cursor to go towards
var cursor_target_pos := Vector2.ZERO
var game_focused := true

var mouseCurseIntensity := 0;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)  # just hide the system cursor
	cursor_target_pos = get_viewport().get_visible_rect().size / 2
	global_position = cursor_target_pos
	
	var timer := Timer.new()
	timer.wait_time = 2
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	cursor_target_pos = Vector2(
		randf_range(100, get_viewport().get_visible_rect().size.x - 100),
		randf_range(100, get_viewport().get_visible_rect().size.y - 100)
	)

func _process(_delta: float) -> void:
	if not game_focused:
		return

	global_position = get_global_mouse_position()  # position of fake cursor sprite
	
	if mouseCurseIntensity > 0:
		handle_cursed_mouse();

func handle_cursed_mouse() -> void:
	var mouse_pos = get_viewport().get_mouse_position()  # local mouse pos

	var resistance_strength := .5 * mouseCurseIntensity
	var delta = mouse_pos - cursor_target_pos
	
	if delta.length() > 10.0:
		var resistance = -delta.normalized() * resistance_strength
		DisplayServer.warp_mouse(mouse_pos + resistance)

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		game_focused = true
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		game_focused = false
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		game_focused = false
