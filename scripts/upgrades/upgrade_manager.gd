class_name UpgradeManager
extends Node

@export var upgrade_container: VBoxContainer;
@export var score_manager: ScoreManager;

const UPGRADE_BUTTON = preload("res://scenes/upgrade_button.tscn")
const CLICK_STRENGTH = preload("res://scripts/upgrades/click_strength.tres")
const DOUBLE_FINGER_BUTTON = preload("res://scripts/upgrades/double_finger_button.tres")
const SINGLE_FINGER_BUTTON = preload("res://scripts/upgrades/single_finger_button.tres")
const SLAP_BUTTON = preload("res://scripts/upgrades/slap_button.tres")


var upgrades := {
	"clickStrength": {
		"resource": preload("res://scripts/upgrades/click_strength.tres"),
		"unlock_condition": func(): return true,
		"spawnCb": func(): print("Click strength boosted"),
	},
	"singleFingerButton": {
		"resource": SINGLE_FINGER_BUTTON,
		"unlock_condition": func(): return score_manager._total_earned >= 20,
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
		"resource": preload("res://scripts/upgrades/double_finger_button.tres"),
		"unlock_condition": func(): return score_manager._total_earned >= 50,
		"spawnCb": func(): print("doubleFingerButton pressed"),
	},
	"slapButton": {
		"resource": preload("res://scripts/upgrades/slap_button.tres"),
		"unlock_condition": func(): return score_manager._total_earned >= 100,
		"spawnCb": func(): print("slapButton pressed"),
	},
	#"cursedMouse": {
		#"resource": preload("res://scripts/upgrades/click_strength.tres"),
		#"unlock_condition": func(): return true,
	#},
	#"cursedClicker": {
		#"resource": preload("res://scripts/upgrades/click_strength.tres"),
		#"unlock_condition": func(): return true,
	#},
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
	var totalAdd = 0;
	for key in upgrades.keys():
		var data = upgrades[key]
		if data.has("ui_node"):
			var upgrade_stats: UpgradeStats = data["resource"]
			if upgrade_stats.amount_owned > 0:
				var scene = data["ui_node"];
				scene.fire_step()

func _spawn_upgrades():
	for key in upgrades.keys():
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
		var should_show = data["unlock_condition"].call()
		if should_show:
			data["upgrade_node"].visible = true

func _update_affordability():
	for key in upgrades.keys():
		var data = upgrades[key]
		var upgrade: UpgradeStats = data["resource"]
		var cost = upgrade.get_next_cost()
		var button: UpgradeButton = data["upgrade_node"]
		var cost_label = button.costLabel

		button.disabled = score_manager.current_score < cost
		cost_label.text = "Cost: %.0f" % cost

func _on_buy_pressed(key: String, upgradeBtn: UpgradeButton) -> void:
	var upgradeData = upgrades[key]
	if !upgradeData: return;
	
	SignalBus.UpgradePurchased.emit(upgradeData["resource"].get_next_cost())
	upgradeBtn.statsRes.purchase()
	if !upgradeData.has('ui_node'):
		var scene = upgradeData.spawnCb.call();
		upgradeData['ui_node'] = scene

func _on_score_update(key: String) -> void:
	var upgradeData = upgrades[key]
	print("--before ", upgradeData)
	pass;

# All upgrades will be added, but will only be visible once "isVisible" set to true.
# - this requires some parms to be met
# Upgrade needs to spawn
# Upgrade should show cost on right
# Upgrade must be grayed out / disabled until can afford
# When upgrade clicked, a certain spawn event should happen. Ex: Spawn SingleFingerButton
