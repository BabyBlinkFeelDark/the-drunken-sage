extends StatePlayer

var already_hit: bool
var power_modifer: int

func enter(_msg: Dictionary = {}):
	already_hit = false


func inner_process(_delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")
	player.anim_pl.play("attack_1")
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/50)
	player.move_and_slide()
	
	if player.anim.get_frame() == 1:
		player.second_attack_zone.set_monitoring(true)
	elif player.anim.get_frame() == 2:
		player.second_attack_zone.set_monitoring(false)
	
	if Input.is_action_just_pressed("attack") and player.canCombo == true:
		state_machine.change_to("Attack_combo2")
	
	


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to("Air",{do_jump=true})
	elif player.is_on_floor():
		if player.velocity.x==0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	


func _on_attack_1_area_entered(area: Area2D) -> void:
	print("yes")
	if not already_hit:
		print("second")
		if area.has_method("hit"):
			area.hit(Player.SECOND_ATTACK_MODIFICATOR)
		already_hit=true
