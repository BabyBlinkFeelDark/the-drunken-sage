extends Area2D
class_name Back

@onready var skull_wolf = owner as SkullWolf
	
func hit(value: int = 0):
	if owner.can_take_damage:
		print("It s %s!"%name)
		owner.can_take_damage=false
		skull_wolf.take_hit(value*2)
		owner.reset_damage_flag()
