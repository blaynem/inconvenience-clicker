extends Resource
class_name UpgradeStats

@export var name: String = "Upgrade"
@export var flavor_text: String = "Upgrades the thing!"
@export var cost: float = 10.0
@export var amount_owned: int = 0
@export var base_production: float = 1.0  # e.g., clicks per second
@export var cost_multiplier: float = 1.15  # cost increases per purchase
@export var scene: PackedScene;

func get_production() -> float:
	return base_production * amount_owned

func get_next_cost() -> int:
	return int(cost * pow(cost_multiplier, amount_owned))

func purchase() -> void:
	amount_owned += 1;
