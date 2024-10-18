extends NPC
class_name SkullWolf
@onready var anim = $AnimatedSprite2D

@onready var navigator = $NavigationAgent2D as NavigationAgent2D
const SPEED = 4000.0
@onready var health = 150
var its_player: bool = false
var attack_cooldown: float = 1.5
var time_since_last_attack: float = 0
var time_to_search: float
var del
var target_player
var can_take_damage: bool = true
var default_damage = 10
var can_mooving:bool = true
@onready var front = $HurtBox/Front
@onready var back = $HurtBox/Back
@onready var hit_box = $HitBoxes
@onready var hurtbox = $HurtBox
enum {
	IDLE,
	WALK,
	DEATH,
	HIT,
	CHASE,
	DAMAGE
}
var state: int = 0:
	set(value):
		state=value

		


func _ready() -> void:

	state = WALK
	pass
	
func _physics_process(delta: float) -> void:
	match state:
		WALK:
			walk_state(del)
			pass
		DEATH:
			death_state()
			pass
		HIT:
			pass
			hit_state()
		DAMAGE:
			damage_state()
		CHASE:
			pass
	
	
	if target_player:
		if target_player.position.x - global_position.x>0:
			direction.x=1
		elif target_player.position.x - global_position.x<0:
			direction.x=-1
	del = delta
	$Label.set_text(str(health))
	move_and_slide()
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	if health<=0:
		alive=false



func walk_state(vel_del):
	$HurtBox/Back/Back.disabled = false
	$HurtBox/Front/Front.disabled = false
	if velocity.x == 0:
		anim.play("idle")
	if can_mooving:
		if target_player:
			#Перемещение тела к игроку
			velocity.x = SPEED * direction.x * del
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("run")
	
	
	if direction == Vector2(-1, 0):
		anim.play("Walk")
	elif direction == Vector2(1,0):
		anim.play("Walk")
	if direction.x < 0:
		anim.set_flip_h(false)
		$HurtBox.set_scale(Vector2(1,1))
		$HurtBox/Front/Front.disabled = false
		$HurtBox/Back/Back.disabled = false
	elif direction.x > 0:
		$HurtBox.set_scale(Vector2(-1,1))
		anim.set_flip_h(true)
		$HurtBox/Front/Front.disabled = false
		$HurtBox/Back/Back.disabled = false
		
	if alive:
		if its_player==true:
			state = HIT
	else:
		state=DEATH


func death_state():
	velocity = Vector2.ZERO
	anim.play("death")
	await anim.animation_finished
	queue_free()	


func hit_state():
	velocity.x = move_toward(velocity.x, 0, SPEED*100)
	#Дожидаемся отката кулдауна и наносим удар, вызывая функцию hit
	time_since_last_attack+=get_process_delta_time()
	if time_since_last_attack>=attack_cooldown:
		anim.play("attack")
		hit()
		await anim.animation_finished
	if its_player == false:
		state = WALK

##Фунция нанесения урона игроку	
func hit():
	Global.player_hp-=default_damage
	time_since_last_attack = 0


func damage_state():
	velocity = Vector2.ZERO
	anim.play("damage")
	await anim.animation_finished

	state=WALK
	
func _on_chase_area_body_entered(body: Node2D) -> void:
	target_player=body	
	state=WALK
	pass 


func _on_chase_area_body_exited(body: Node2D) -> void:
	target_player = null

func _is_can_move(_dont_move):
	#can_mooving = !_dont_move
	pass
	
func take_hit(value: int):
	health-=value
	state = DAMAGE

func reset_damage_flag():
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true
