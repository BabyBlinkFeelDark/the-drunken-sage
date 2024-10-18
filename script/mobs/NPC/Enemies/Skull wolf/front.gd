extends Area2D
class_name Front

@onready var skull_wolf = owner as SkullWolf
@onready var hurtbox: HurtBox


func hit(value: int = 0):
	if owner.can_take_damage:
		print("It s %s!"%name)
		owner.can_take_damage=false
		skull_wolf.take_hit(value)
		owner.reset_damage_flag()
