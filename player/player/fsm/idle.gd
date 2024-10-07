extends StatePlayer

func enter(_msg: Dictionary={}):
	pass


func inner_physics_process(_delta: float) -> void:
	player.jump_counter=0
	if not player.is_on_floor():
		state_machine.change_to("Air")
	elif  Input.is_action_just_pressed("jump"):
		state_machine.change_to("Air",{do_jump=true})	
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_to("Attack")	
	elif  Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_to("Run")
	player.anim_pl.play("idle")
