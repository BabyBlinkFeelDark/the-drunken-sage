class_name StatePlayer
extends State

var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = owner as Player
	pass
