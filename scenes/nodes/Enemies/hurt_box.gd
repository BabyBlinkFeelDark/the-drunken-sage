extends Node2D
class_name HurtBox
@onready var front = $Front as Front
@onready var back = $Back as Back
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Front/Front.disabled = false
	#$Back/Back.disabled = false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#print ("front.disable ", $Front/Front.disabled)
	pass


func reload():
	#$Front/Front.disabled = true
	#$Back/Back.disabled = true
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	#$Front/Front.disabled = false
	#$Back/Back.disabled = false
	pass
