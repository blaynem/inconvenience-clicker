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
	statsRes = res;
	hint_text_label.text = res.flavor_text;
	nameLabel.text = res.name;
	costLabel.text = str(res.get_next_cost());

func _on_mouse_entered() -> void:
	if !disabled:
		hint_text_label.visible = true;

func _on_mouse_exited() -> void:
	hint_text_label.visible = false;
