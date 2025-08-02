class_name MainCounterButton
extends Button

var _resource: UpgradeStats;
func attach_resource(resource: UpgradeStats) -> void:
	_resource = resource

func fire_step() -> void:
	SignalBus.AddToScore.emit(_resource)

func _on_pressed() -> void:
	SignalBus.ClickPressed.emit()
