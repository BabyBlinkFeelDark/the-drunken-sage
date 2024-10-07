extends StatePlayer

func enter(_mgs: Dictionary = {}):

	pass
func inner_physics_process(_delta):
	player.jump_counter=0
	
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	if Input.is_action_just_pressed("attack"):
		state_machine.change_to("Attack")	
	if Input.is_action_just_pressed("dash") and player.canDash==true:
		state_machine.change_to("Dash")	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to("Air",{do_jump = true})
	var direction := Input.get_axis("left", "right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/10)
		
		
	if direction == -1 and not player.anim.is_flipped_h():
		player.anim.flip_h=true
		player.u_turn.emit("left")
	elif direction == 1 and player.anim.is_flipped_h():
		player.anim.flip_h=false
		player.u_turn.emit("right")	
	player.move_and_slide()
	
	if player.velocity.x == 0 and direction == 0:
		state_machine.change_to("Idle")
	player.anim_pl.play("walk")
