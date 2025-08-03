class_name UpgradeButton
extends Button

@onready var nameLabel: Label = $MarginContainer/HBoxContainer/Name
@onready var costLabel: Label = $MarginContainer/HBoxContainer/Cost
@onready var hint_text_label: Label = $HintTextLabel

var statsRes: UpgradeStats;

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	hint_text_label.visible = false;

func setup_button(res: UpgradeStats) -> void:
	statsRes = res
	hint_text_label.text = res.flavor_text
	
	var owned_prefix = ""
	if res.amount_owned > 0:
		owned_prefix = "(%d) " % res.amount_owned
	
	nameLabel.text = "%s%s" % [owned_prefix, res.name]
	costLabel.text = "Cost: $%.0f" % res.get_next_cost()

func _on_mouse_entered() -> void:
	hint_text_label.visible = true;

func _on_mouse_exited() -> void:
	hint_text_label.visible = false;
