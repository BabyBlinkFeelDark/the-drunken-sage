extends Marker2D

@onready var player = owner as Player
var time_passed = 0
var amplitude = 1.2  # Амплитуда синусоиды
var frequency = 1.2    # Частота синусоиды
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	owner.u_turn.connect(_on_player_u_turn)
	
func _process(delta: float) -> void:
	time_passed+=delta
	
	
func _on_player_u_turn(anim_direction):
	if owner.velocity.y==0:
		$Camera2D.set_limit_smoothing_enabled(10)
	else:
		$Camera2D.set_limit_smoothing_enabled(100)
	match anim_direction:
		"right":
			position.x=50
			position.y=-50+amplitude * sin(time_passed * frequency)
		"left":
			position.x=-50
			position.y=-50+amplitude * sin(time_passed * frequency)
