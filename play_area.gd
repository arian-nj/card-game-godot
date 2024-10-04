extends Area2D

var is_active : bool = false

func _ready():
	await get_tree().create_timer(1).timeout
	is_active = true

func _on_area_entered(area) -> void:
	if is_active and area.typeof is Card:
		print("hii2")
