class_name ScoreManager
extends Node

@export var score_label: Label;

var _total_earned := 0;
var current_score := 0;

func _ready() -> void:
	SignalBus.AddToScore.connect(_add_score_fired)
	SignalBus.UpgradePurchased.connect(_upgrade_purchased)
	_on_score_update();

func _add_score_fired(res: UpgradeStats, multiplyer: int = 1) -> void:
	var produced = res.get_production() * multiplyer;
	current_score += produced
	_total_earned += produced
	_on_score_update()

func _upgrade_purchased(upgrade: UpgradeStats) -> void:
	current_score -= upgrade.get_next_cost()
	_on_score_update()

func _on_score_update() -> void:
	var format_score := "Total Earned: $%s   Money: $%s"
	score_label.text = format_score % [_total_earned, current_score]
