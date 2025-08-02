class_name ScoreManager
extends Node

@export var score_label: Label;

var _total_earned := 0;
var current_score := 0;

func _ready() -> void:
	SignalBus.AddToScore.connect(_add_score_fired)
	SignalBus.UpgradePurchased.connect(_upgrade_purchased)

func _add_score_fired(res: UpgradeStats) -> void:
	current_score += res.get_production()
	_total_earned += res.get_production()
	_on_score_update()

func _upgrade_purchased(cost: int) -> void:
	current_score -= cost
	_on_score_update()

func _on_button_pressed() -> void:
	SignalBus.ClickPressed.emit()
	_on_score_update()

func _on_score_update() -> void:
	var format_score := "Score: %s"
	score_label.text = format_score % current_score
