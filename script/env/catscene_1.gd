extends Node2D
class_name CatScene

var isCatscene:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play("start")
	Global.emit_signal("catscene",isCatscene)
	$level/Player/Pivot/Camera2D.enabled = false
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://textures/background/level.tscn")
	pass
