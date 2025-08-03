extends Resource
class_name UpgradeStats

@export var name: String = "Upgrade"
@export var flavor_text: String = "Upgrades the thing!"
@export var cost: float = 10.0
@export var amount_owned: int = 0
@export var base_production: float = 1.0  # e.g., clicks per second
@export var cost_multiplier: float = 1.15  # cost increases per purchase
@export var scene: PackedScene;
@export var max_ownable: int = 1;
@export var multiplier := 0;
@export var unlock_at_score := 0;

func get_production() -> float:
	return base_production * amount_owned

func get_next_cost() -> int:
	return int(cost * pow(cost_multiplier, amount_owned))

func purchase() -> void:
	if can_purchase():
		SignalBus.UpgradePurchased.emit(self)
		amount_owned += 1;

func can_purchase() -> bool:
	return amount_owned < max_ownable
