extends Node

func display_numer(value: int, position: Vector2, scale: Vector2 = Vector2(1,1)) -> void:
	var number = Label.new()
	number.global_position = position
	number.text = "+" + str(value)
	number.z_index = 5;
	number.scale = scale
	
	var color = Color.GREEN
	if value < 0:
		color = Color.FIREBRICK

	var labelsettings = LabelSettings.new();
	labelsettings.font_color = color
	labelsettings.font_size = 18
	labelsettings.outline_color = Color.WHITE
	labelsettings.outline_size = 1
	
	number.label_settings = labelsettings
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
