extends ParallaxBackground

var BG_velosity=25

func _process(delta: float) -> void:
	if Global.player_velocity:
		scroll_offset.x-= BG_velosity * delta * 100
