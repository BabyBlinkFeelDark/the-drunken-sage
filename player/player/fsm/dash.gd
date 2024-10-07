extends StatePlayer

func enter(_mgs: Dictionary = {}):
	pass 
	
func inner_physics_process(_delta):		


	var direction := Input.get_axis("left", "right")
	if direction:
		player.velocity.x = direction * player.SPEED * player.DASH_MODIFICATOR
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/10)
		
		
	if direction == -1 and not player.anim.is_flipped_h():
		player.anim.flip_h=true
		player.u_turn.emit("left")
	elif direction == 1 and player.anim.is_flipped_h():
		player.anim.flip_h=false
		player.u_turn.emit("right")	

	
	player.move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state_machine.change_to("Attack")	
	elif player.velocity.x == 0 and direction == 0:
		state_machine.change_to("Idle")
	player.anim_pl.play("dash")
	
func exit(_msg: Dictionary = {}):
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED*4)
	pass	
	
func dash_cold_down():	
	player.canDash=false
	await get_tree().create_timer(player.COLDDOWN_DASH).timeout
	player.canDash=true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not player.is_on_floor():
		state_machine.change_to("Air")
		
