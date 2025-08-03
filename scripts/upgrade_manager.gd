class_name UpgradeManager
extends Node

@export var upgrade_container: VBoxContainer;
@export var score_manager: ScoreManager;

const AUTO_CLICKER = preload("res://scripts/upgrades/auto_clicker.tres")
const UPGRADE_BUTTON = preload("res://scenes/upgrade_button.tscn")
const CLICK_STRENGTH = preload("res://scripts/upgrades/click_strength.tres")
const DOUBLE_FINGER_BUTTON = preload("res://scripts/upgrades/double_finger_button.tres")
const SINGLE_FINGER_BUTTON = preload("res://scripts/upgrades/single_finger_button.tres")
const SLAP_BUTTON = preload("res://scripts/upgrades/slap_button.tres")
const CURSED_MOUSE = preload("res://scripts/upgrades/cursed_mouse.tres")
const ATTEMPT_FIX_CURSED_MOUSE = preload("res://scripts/upgrades/attempt_fix_cursed_mouse.tres")
const REVERT_CURSED_MOUSE = preload("res://scripts/upgrades/revert_cursed_mouse.tres")
const SHRINKING_BUTTON = preload("res://scripts/upgrades/shrinking_button.tres")
const CLICK_LIMITER = preload("res://scripts/upgrades/click_limiter.tres")
const CLICK_LIMITER_2 = preload("res://scripts/upgrades/click_limiter_2.tres")
const CURSED_BUTTON = preload("res://scripts/upgrades/cursed_button.tres")
const AUTO_CLICKER_FUEL = preload("res://scripts/upgrades/auto_clicker_fuel.tres")
const MAGIC_OFF_SWITCH = preload("res://scripts/upgrades/magic_off_switch.tres")
const WIN_GAME = preload("res://scripts/upgrades/win_game.tres")

var upgrades := {
	"winGame": {
		"resource": WIN_GAME,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= WIN_GAME.unlock_at_score,
		"spawnCb": func():
			const WINNING_SCREEN = preload("res://scenes/winning_screen.tscn")
			get_tree().change_scene_to_packed(WINNING_SCREEN),
	},
	"clickStrength": {
		"resource": CLICK_STRENGTH,
		"unlock_condition": func(ref: UpgradeManager): 
			return score_manager._total_earned >= CLICK_STRENGTH.unlock_at_score,
		"spawnCb": func(): print("Click strength boosted"),
	},
	"autoClickerFuel": {
		"resource": AUTO_CLICKER_FUEL,
		"unlock_condition": func(ref: UpgradeManager):
			var autoClicker: UpgradeStats = ref.upgrades.autoClickerButton.resource
			return autoClicker.amount_owned > 0 && score_manager._total_earned >= AUTO_CLICKER_FUEL.unlock_at_score,
		"spawnCb": func(): pass,
	},
	"singleFingerButton": {
		"resource": SINGLE_FINGER_BUTTON,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= SINGLE_FINGER_BUTTON.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var scene: SingleFingerButton = SINGLE_FINGER_BUTTON.scene.instantiate()
			var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
			var marker: Node2D = mainNode.get_node("singleFinger")
			mainNode.add_child(scene)
			scene.position = marker.position
			scene.attach_resource(SINGLE_FINGER_BUTTON)
			return scene,
	},
	"doubleFingerButton": {
		"resource": DOUBLE_FINGER_BUTTON,
		"unlock_condition": func(ref: UpgradeManager): 
			return score_manager._total_earned >= DOUBLE_FINGER_BUTTON.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var scene: DoubleFingerButton = DOUBLE_FINGER_BUTTON.scene.instantiate()
			var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
			var marker: Node2D = mainNode.get_node("doubleFinger")
			mainNode.add_child(scene)
			scene.position = marker.position
			scene.attach_resource(DOUBLE_FINGER_BUTTON)
			return scene,
	},
	"slapButton": {
		"resource": SLAP_BUTTON,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= SLAP_BUTTON.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var scene: SlapButton = SLAP_BUTTON.scene.instantiate()
			var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
			var marker: Node2D = mainNode.get_node("slapButton")
			mainNode.add_child(scene)
			scene.position = marker.position
			scene.attach_resource(SLAP_BUTTON)
			return scene,
	},
	"autoClickerButton": {
		"resource": AUTO_CLICKER,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= AUTO_CLICKER.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var scene: AutoClickerButton = AUTO_CLICKER.scene.instantiate()
			var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
			var marker: Node2D = mainNode.get_node("autoClicker")
			mainNode.add_child(scene)
			scene.position = marker.position
			scene.attach_resource(AUTO_CLICKER)
			scene.upgradeManager = self;
			scene.start_auto_clicking()
			return scene,
	},
	"magicSwitch": {
		"resource": MAGIC_OFF_SWITCH,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= MAGIC_OFF_SWITCH.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var scene: MagicOffSwitch = MAGIC_OFF_SWITCH.scene.instantiate()
			var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
			var marker: Node2D = mainNode.get_node("magicSwitch")
			mainNode.add_child(scene)
			scene.position = marker.position
			scene.attach_resource(MAGIC_OFF_SWITCH)
			return scene,
	},
	"cursedMouse": {
		"resource": CURSED_MOUSE,
		"unlock_condition": func(ref: UpgradeManager):
			var autoClicker: UpgradeStats = ref.upgrades.autoClickerButton.resource
			return autoClicker.amount_owned > 0 && score_manager._total_earned >= CURSED_MOUSE.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var cursorNode: Cursor = get_node("%Cursor")
			cursorNode.mouseCurseIntensity = 3;
			return null,
	},
	"attemptFixCursedMouse": {
		"resource": ATTEMPT_FIX_CURSED_MOUSE,
		"unlock_condition": func(ref: UpgradeManager):
			var cursedRes: UpgradeStats = ref.upgrades.cursedMouse.resource
			return cursedRes.amount_owned > 0 && score_manager._total_earned >= ATTEMPT_FIX_CURSED_MOUSE.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var cursorNode: Cursor = get_node("%Cursor")
			cursorNode.mouseCurseIntensity = 1.4;
			return null,
	},
	"revertCursedMouse": {
		"resource": REVERT_CURSED_MOUSE,
		"unlock_condition": func(ref: UpgradeManager):
			var fixCursedRes: UpgradeStats = ref.upgrades.attemptFixCursedMouse.resource
			return fixCursedRes.amount_owned > 0 && score_manager._total_earned >= REVERT_CURSED_MOUSE.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var cursorNode: Cursor = get_node("%Cursor")
			cursorNode.mouseCurseIntensity = 0;
			return null,
	},
	"shrinkingButton": {
		"resource": SHRINKING_BUTTON,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= SHRINKING_BUTTON.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var button: MainCounterButton = get_node("%MainCounterButton")
			button.shrinkEnabled = true;
			return null,
	},
	"clickLimiter": {
		"resource": CLICK_LIMITER,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= CLICK_LIMITER.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var button: MainCounterButton = get_node("%MainCounterButton")
			button.clickLimiterEnabled = true;
			return null,
	},
	"clickUnLimiter": {
		"resource": CLICK_LIMITER_2,
		"unlock_condition": func(ref: UpgradeManager):
			var clickLimiter: UpgradeStats = ref.upgrades.clickLimiter.resource
			return clickLimiter.amount_owned > 0 && score_manager._total_earned >= CLICK_LIMITER_2.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var button: MainCounterButton = get_node("%MainCounterButton")
			button.MAX_CLICKS = 50;
			return null,
	},
	"cursedButton": {
		"resource": CURSED_BUTTON,
		"unlock_condition": func(ref: UpgradeManager):
			return score_manager._total_earned >= CURSED_BUTTON.unlock_at_score,
		"spawnCb": func() -> Node2D:
			var button: MainCounterButton = get_node("%MainCounterButton")
			button.isButtonCursed = true;
			return null,
	}
}


func _ready() -> void:
	# Render the MainCounterbutton
	var mainCounterBtn: MainCounterButton = %MainCounterButton
	var clickData = upgrades["clickStrength"]
	mainCounterBtn.attach_resource(clickData.resource)
	clickData['ui_node'] = mainCounterBtn
	
	SignalBus.ClickPressed.connect(_fire_clicks)
	_spawn_upgrades();

func _process(delta: float) -> void:
	_update_upgrade_visibility()
	_update_affordability()

func _fire_clicks():
	for key in upgrades.keys():
		var data = upgrades[key]
		if data.has("ui_node") and data["ui_node"] != null:
			var upgrade_stats: UpgradeStats = data["resource"]
			if upgrade_stats.amount_owned > 0:
				data["ui_node"].fire_step()

func _spawn_upgrades():
	var sorted_keys = upgrades.keys()
	sorted_keys.sort_custom(func(a, b):
		return upgrades[a]["resource"].get_next_cost() < upgrades[b]["resource"].get_next_cost()
	)
	
	for key in sorted_keys:
		var data = upgrades[key]
		var upgrade_stats: UpgradeStats = data["resource"]
		
		var btn_instance = UPGRADE_BUTTON.instantiate()
		upgrade_container.add_child(btn_instance)
		btn_instance.setup_button(upgrade_stats)
		btn_instance.pressed.connect(_on_buy_pressed.bind(key, btn_instance))
		btn_instance.visible = false;
		
		data["upgrade_node"] = btn_instance

func _update_upgrade_visibility():
	for key in upgrades.keys():
		var data = upgrades[key]
		var res: UpgradeStats = data["resource"]
		# If we can't purchase, no need to show it.
		if !res.can_purchase():
			data["upgrade_node"].visible = false
			continue;
		
		var should_show = data["unlock_condition"].call(self)
		if should_show:
			data["upgrade_node"].visible = true

func _update_affordability():
	for key in upgrades.keys():
		var data = upgrades[key]
		var upgrade: UpgradeStats = data["resource"]
		var cost = upgrade.get_next_cost()
		var button: UpgradeButton = data["upgrade_node"]

		button.disabled = score_manager.current_score < cost
		button.setup_button(upgrade)

func _on_buy_pressed(key: String, upgradeBtn: UpgradeButton) -> void:
	var upgradeData = upgrades[key]
	if !upgradeData: return;
	
	upgradeBtn.statsRes.purchase()
	var mainBtn: MainCounterButton = get_node("%MainCounterButton")
	mainBtn.clickMultiplier += upgradeBtn.statsRes.multiplier
	if !upgradeData.has('ui_node'):
		var scene = upgradeData.spawnCb.call();
		upgradeData['ui_node'] = scene
	
	if key == "autoClickerFuel":
		var mainNode = get_tree().root.get_node("/root/UI/UpgradesHolder")
		var autoClicker: AutoClickerButton = mainNode.get_node("AutoClicker")
		autoClicker.current_fuel = clamp(autoClicker.current_fuel + autoClicker.base_fuel,0, autoClicker.max_fuel)
