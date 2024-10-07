extends CharacterBody2D

enum {
	WALK,
	DEATH,
	JUMP,
	FALL,
	CLIMB,
	ATTACK,
	DASH,
	DAMAGE
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
var health = 100
var money = 0
var jump_scale = 2
var state = WALK
var DASH_VEL = 1
var canDash = true
var canClipb = true
var inJump = false
var cooldown_dash = 0
var itsDamage = false
var itsWall=false
@onready var catscene: CatScene
var is_catscene: bool
var start_catscene: bool
signal u_turn
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	Global.connect("catscene", Callable(self, "_on_catscene"))


	if not start_catscene:
		cooldown_dash+=get_process_delta_time()
		$Pivot/Camera2D.position_smoothing_enabled=true
		match state:
			WALK:
				walk_state(delta)
			JUMP:
				jump_state()
			FALL:
				fall_state()
			CLIMB:
				pass
			ATTACK:
				pass
			DEATH:
				death_state()
			DASH:
				dash_state(delta)
			DAMAGE:
				damage_state()
		
		if not is_on_floor():
				velocity.y += get_gravity().y * delta
		else:
			jump_scale=0
			itsWall=false
		
		move_and_slide()
	
	

	

func walk_state(vel_del):
	$PointLight2D.energy = 0
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED #* vel_del
		if velocity.y == 0:
			anim_player.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim_player.play('Idle')
		
	if direction == -1:
		u_turn.emit("left")
		anim.flip_h=true
	elif direction == 1:
		u_turn.emit("right")	
		anim.flip_h=false
	
	
	
	if Input.is_action_just_pressed("dash") and cooldown_dash>0.5:
		state=DASH
	if Input.is_action_just_pressed("jump") and jump_scale<3:
		state = JUMP
	if jump_scale>1 and not is_on_floor():
		state = FALL
	if health<=0:
		state=DEATH
	if itsWall==true and jump_scale<3:
		state=CLIMB 


func jump_state():	
	if jump_scale<2:
		jump_scale+=1
		velocity = Vector2.ZERO
		velocity.y += JUMP_VELOCITY
		anim_player.play("Jump")
		
	if itsWall==true and jump_scale<3:
		state=CLIMB
	elif itsWall==false and jump_scale>2:
		state=FALL
	else:
		state=WALK

func dash_state(vel):
	
	var direction := Input.get_axis("left", "right")
	$PointLight2D.energy = lerpf(2,0,0.1)


	
	if direction==0:
		if anim.flip_h:
			velocity.x+=+1000

		else:
			velocity.x+=-1000

	else:
		anim_player.play("Dash")
		$Pivot.position.x=150*direction
		velocity.x+=(50*direction)
		velocity.y += 0
		await anim_player.animation_finished
		
	if jump_scale>2:
		state=FALL
	else:	
		state=WALK
	cooldown_dash = 0 
	

func climb_state():
	var direction := Input.get_axis("left", "right")
	#if Input.is_action_pressed("jump") and jump_scale<3 and canClipb==true:
		#anim_player.play("grip")
		#velocity.y=-direction * SPEED * 2
	#elif jump_scale<3 and canClipb==true and itsWall==true:
		#anim_player.play("fall")
		#velocity = Vector2.ZERO
	##itsWall=false
	#if Input.is_action_just_pressed("jump") and jump_scale<3:
		#state = JUMP
		#itsWall=false
	#elif jump_scale>1 and not is_on_floor():
		#state = FALL
	#elif Input.is_action_just_pressed("bash") and direction!=0:
		#state = DASH
	#else:
		#state = WALK
		#await get_tree().create_timer(colddown_climp).timeout
		#canClipb=true	
	
func damage_state():
	anim_player.play("damage")
	await anim_player.animation_finished
	state = WALK
	pass


func _on_detect_wall_body_entered(body: Node2D) -> void:
	itsWall=true


func _on_detect_wall_body_exited(body: Node2D) -> void:
	itsWall=false
	state=WALK

	
func fall_state():
	if not is_on_floor():
		anim_player.play("fall")
	
	if Input.is_action_just_pressed("bash"):
		state=DASH
	else:
		state=WALK
		
func death_state():
	if health<=0:
		health=0
		anim_player.play("death")
		await anim_player.animation_finished
		queue_free()
		get_tree(). change_scene_to_file("res://scene/menu.tscn")
		
#func cold_dash():
		#canDash=false
		#await get_tree().create_timer(colddown_dash).timeout
		#canDash=true
		
func _on_catscene(is_catscene):
	start_catscene = true
