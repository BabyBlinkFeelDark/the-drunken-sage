extends StatePlayer

var already_hit: bool
var power_modifer: int


func enter(_msg: Dictionary = {}):
	already_hit = false



func inner_process(_delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	if player.anim.is_flipped_h():
		player.third_attack_zone.set_scale(Vector2(-1,1))
		player.anim_fx.flip_h=false

	else:	
		player.third_attack_zone.set_scale(Vector2(1,1))
		player.anim_fx.flip_h=true

	
	
	player.anim_pl.play("attack_2")
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/50)
	player.move_and_slide()
	

	

	if player.anim.get_frame() == 1:
		player.third_attack_zone.set_monitoring(true)
	elif player.anim.get_frame() == 3:
		player.anim_fx.visible=true
		player.anim_fx.play("Thunder")
	elif player.anim.get_frame() == 4:
		player.third_attack_zone.set_monitoring(false)
		player.third_attack_zone.set_monitorable(false)
	elif player.anim.get_frame() == 7:
		player.anim_fx.visible=false



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.change_to("Attack")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_to("Air",{do_jump=true})
	elif player.is_on_floor():
		if player.velocity.x==0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	

func _on_attack_2_area_entered(area: Area2D) -> void:
	if not already_hit:
		print("trird")
		if area.has_method("hit"):
			area.hit(Player.TRIRD_ATTACK_MODIFICATOR)
		already_hit=true
