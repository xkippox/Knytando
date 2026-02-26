extends Node2D

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var visible_time: float = 2.0
@export var blink_speed: float = 0.15

@onready var container = $HBoxContainer

var blinking = false


func _ready():
	modulate.a = 0 # começa invisível


func show_hearts(current, maximum, is_start):

	update_hearts(current, maximum)

	modulate.a = 1
	visible = true

	if is_start:
		await fade_out()
	else:
		await blink_then_hide()


func update_hearts(current, maximum):

	for i in range(container.get_child_count()):

		var heart = container.get_child(i)

		if i < current:
			heart.texture = heart_full
		else:
			heart.texture = heart_empty


func fade_out():

	await get_tree().create_timer(visible_time).timeout

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)

	await tween.finished
	visible = false


func blink_then_hide():

	blinking = true

	var elapsed = 0.0

	while elapsed < visible_time:

		visible = not visible
		await get_tree().create_timer(blink_speed).timeout
		elapsed += blink_speed

	visible = false
	blinking = false
