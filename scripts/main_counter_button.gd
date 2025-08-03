class_name MainCounterButton
extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var shrink_timer: Timer = Timer.new()
@onready var cooldown_timer: Timer = Timer.new()
@onready var hover_move_timer: Timer = Timer.new()

var isButtonCursed := false;
var clickLimiterEnabled := false;
var shrinkEnabled := false;
var current_size := 100;

var click_count := 0
var MAX_CLICKS := 10
const CLICK_WINDOW := 5.0 # seconds
const COOLDOWN_DURATION := 2.0 # seconds

var _resource: UpgradeStats;

var clickMultiplier := 1;

func attach_resource(resource: UpgradeStats) -> void:
	_resource = resource

func fire_step() -> void:
	handle_click_effects();

func _on_pressed() -> void:
	# Emits the clickPressed which is then handled by fire_step
	SignalBus.ClickPressed.emit()

func _ready() -> void:
	SignalBus.MagicSwitchToggled.connect(_on_magic_switch_toggled);
	# Shrink timer setup
	shrink_timer.wait_time = 0.05
	shrink_timer.one_shot = false
	shrink_timer.autostart = false
	add_child(shrink_timer)
	shrink_timer.timeout.connect(_on_shrink_timer_timeout)

	# Cooldown timer setup
	cooldown_timer.wait_time = CLICK_WINDOW
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = false
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	
	hover_move_timer.wait_time = .25
	hover_move_timer.one_shot = false
	hover_move_timer.autostart = false
	add_child(hover_move_timer)
	hover_move_timer.timeout.connect(_on_hover_move_timer_timeout)

func handle_click_effects() -> void:
	if not disabled:
		var produced := _resource.get_production() * clickMultiplier;
		ScoreGainNumber.display_numer(produced, global_position)
		SignalBus.AddToScore.emit(_resource, clickMultiplier)
		audio_stream_player.play()
		
		# Shrink logic
		if shrinkEnabled:
			if scale.x > 0.2:
				scale -= Vector2(0.1, 0.1)
			shrink_timer.start()

		if clickLimiterEnabled:
			# Click tracking for cooldown
			click_count += 1
			print(cooldown_timer.is_stopped())
			if not cooldown_timer.is_stopped():
				if click_count >= MAX_CLICKS:
					disabled = true
					await get_tree().create_timer(COOLDOWN_DURATION).timeout
					disabled = false
					click_count = 0
					cooldown_timer.stop()
			else:
				click_count = 1
				cooldown_timer.start()

func _on_shrink_timer_timeout() -> void:
	if scale.x < 1.0:
		scale += Vector2(0.02, 0.02)
	else:
		scale = Vector2.ONE
		shrink_timer.stop()

func _on_cooldown_timer_timeout() -> void:
	click_count = 0

func _on_mouse_entered() -> void:
	if isButtonCursed:
		hover_move_timer.start()

func _on_mouse_exited() -> void:
	hover_move_timer.stop()

func _on_hover_move_timer_timeout() -> void:
	if isButtonCursed:
		_move_button()

func _on_magic_switch_toggled(_toggled: bool):
	disabled = _toggled;

func _move_button() -> void:
	var parent_rect = get_node("%Left Panel").get_rect() # Assumes parent is Left Panel
	var button_size = size
	var margin = 10

	var new_pos = position + Vector2(randf_range(-100, 100), randf_range(-100, 100))

	# Clamp within parent's rect
	new_pos.x = clamp(
		new_pos.x,
		margin,
		parent_rect.size.x - button_size.x - margin
	)
	new_pos.y = clamp(
		new_pos.y,
		margin,
		parent_rect.size.y - button_size.y - margin
	)

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, hover_move_timer.wait_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
