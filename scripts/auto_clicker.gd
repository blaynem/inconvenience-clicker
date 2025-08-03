class_name AutoClickerButton
extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var finger_point: Sprite2D = $FingerPoint
@onready var large_button: LargeButton = $LargeButton
@onready var marker_2d: Marker2D = $Marker2D
@onready var auto_click_timer: Timer = Timer.new()

var upgradeManager: UpgradeManager;

var _resource: UpgradeStats;
var _init_position: Vector2;
var touchingButtonPoint: Vector2

var current_steps := 0
const VERTICAL_OFFSET := 50; # in px
const PHASE1_STEPS := 5  # number of steps before contact
var step_distance := 0.0

var score_added := false;

var base_fuel := 20;
var max_fuel := 20;
var current_fuel := 20:
	set(val):
		current_fuel = val;
		update_fuel_guage()

func attach_resource(resource: UpgradeStats) -> void:
	_resource = resource

func fire_step() -> void:
	# Ignored since we're in auto clicker.
	pass;

func _ready() -> void:
	SignalBus.UpgradePurchased.connect(_on_upgrade_purchased)
	_init_position = finger_point.position
	touchingButtonPoint = finger_point.position
	finger_point.position.y += VERTICAL_OFFSET
	step_distance = (touchingButtonPoint.y - finger_point.position.y) / PHASE1_STEPS
	update_fuel_guage()
	
	# Auto-click timer setup
	auto_click_timer.wait_time = 1
	auto_click_timer.one_shot = false
	auto_click_timer.autostart = false
	add_child(auto_click_timer)
	auto_click_timer.timeout.connect(_on_auto_click_timer_timeout)

func _on_upgrade_purchased(upgrade: UpgradeStats) -> void:
	if upgrade == _resource:
		var base_cps := 5;
		
		var clicks_per_second := base_cps * sqrt(upgrade.amount_owned)
		auto_click_timer.wait_time = clamp(1.0 / clicks_per_second, 0.05, 3.0)
		max_fuel = base_fuel * upgrade.amount_owned
		current_fuel = max_fuel
		print("CPS:", clicks_per_second, "Wait time:", auto_click_timer.wait_time)

func _on_auto_click_timer_timeout() -> void:
	if current_fuel <= 0: return;
	current_fuel -= 1;
	
	if score_added:
		_lift_finger()
	else:
		_push_finger()

func update_fuel_guage() -> void:
	progress_bar.max_value = max_fuel
	progress_bar.value = current_fuel

func start_auto_clicking() -> void:
	auto_click_timer.start()

func stop_auto_clicking() -> void:
	auto_click_timer.stop()

func _push_finger() -> void:
	if current_steps < PHASE1_STEPS:
		# Phase 1: move finger toward button
		finger_point.position.y += step_distance
	elif large_button.current_step > 0:
		# Phase 2: press the button
		large_button.pressStep()
		if large_button.pressed_called:
			score_added = true;
			ScoreGainNumber.display_numer(_resource.get_production(), marker_2d.global_position)
			audio_stream_player.play()
			upgradeManager._fire_clicks()
			SignalBus.AddToScore.emit(_resource)
	# add 1 to current_steps
	current_steps += 1

func _lift_finger() -> void:
	if large_button.current_step < large_button.max_steps:
		# Phase 2: release the button
		large_button.releaseStep()
	elif current_steps > 0:
		# Phase 1: lift finger away
		finger_point.position.y -= step_distance
	# Remove 1 from current_step
	if current_steps > 0:
		current_steps -= 1
	else:
		score_added = false;
