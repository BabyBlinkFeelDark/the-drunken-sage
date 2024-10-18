extends CharacterBody2D

class_name PlayerTopDown


enum {
	WALK
}

const SPEED = 50.0

@onready var anim = $AnimatedSprite2D

var state = WALK



func _ready() -> void:
	pass
		
func _physics_process(delta: float) -> void:

	match state:
		WALK:
			walk_state(delta)

	move_and_slide()


func walk_state(_vel_del):

	var direction : Vector2
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	
	
	#Передвижение
	if direction:
		velocity = Vector2(direction.x * SPEED,direction.y*SPEED) 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)


		
	#Смена анимации в зависимости от вектора направления Direction
	if direction.x == -1:
		anim.flip_h=false
	elif direction.x == 1: 
		anim.flip_h=true
	if direction.y<0:
		anim.play("up")
	elif direction.y>0:

		anim.play("down")

	elif direction.y==0 and direction.x!=0:
		anim.play("side")
	elif direction==Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		anim.play("idle")
	
