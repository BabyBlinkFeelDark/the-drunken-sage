extends StatePlayer

func enter(msg: Dictionary = {}):

	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY

func inner_physics_process(delta):

	
	if player.velocity.y < 0:
		player.anim_pl.play("jump")
	else:
		player.anim_pl.play("fall")	
		
	if Input.is_action_just_pressed("dash") and player.canDash==true:
		state_machine.change_to("Dash")		
	elif Input.is_action_just_pressed("jump") and player.jump_counter<=1:
		player.jump_counter+=1
		player.anim_pl.play("jump")
		state_machine.change_to("Air",{do_jump = true})
	
			
			
	var direction := Input.get_axis("left", "right")
	player.velocity += player.get_gravity() * delta	
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, 0.5)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/10)
		
	if direction == -1 and not player.anim.is_flipped_h():
		player.anim.flip_h=true
	elif direction == 1 and player.anim.is_flipped_h(): 
		player.anim.flip_h=false
	
	
	if player.is_on_floor():
		if player.velocity.x==0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	player.move_and_slide()
	
	
	
