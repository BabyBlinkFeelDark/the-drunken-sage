extends Marker2D

@onready var player = owner as Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.u_turn.connect(_on_player_u_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func _on_player_u_turn(anim_direction):
	print("fuck to %s"%anim_direction)
	if player.velocity.y==0:
		$Camera2D.set_limit_smoothing_enabled(10)
	else:
		$Camera2D.set_limit_smoothing_enabled(100)
	match anim_direction:
		"right":
			position.x=50
			position.y=-15
		"left":
			position.x=-50
			position.y=-15
