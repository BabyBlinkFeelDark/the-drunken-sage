extends Node2D
var campfire: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	campfire = $Campfire


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	campfire.play("campfire")
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://textures/background/level.tscn")
	
func _on_button_3_pressed() -> void:
	get_tree().quit()	
