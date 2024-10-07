extends StatePlayer


var already_hit: bool
var power_modifer: int
func enter(_msg: Dictionary = {}):
	already_hit = false


	if player.anim.is_flipped_h():
		player.first_attack_zone.set_scale(Vector2(-1,1))
	else:
		player.first_attack_zone.set_scale(Vector2(1,1))
	
	
func inner_process(_delta):
	
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	player.anim_pl.play("attack_0")
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED/50)
	player.move_and_slide()
	if Input.is_action_just_pressed("attack") and player.canCombo == true:
		state_machine.change_to("Attack_combo1")
	
	if player.anim.get_frame() == 1:
		player.first_attack_zone.set_monitoring(true)
	elif player.anim.get_frame() == 3:
		player.first_attack_zone.set_monitoring(false)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to("Air",{do_jump=true})
	elif player.is_on_floor():
		if player.velocity.x==0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
			
func can_combo():
	pass
	player.canCombo = true
	$"../../Control/VBox/l_on_floor".set_text("lets do it")	
func stop_combo():
	pass
	player.canCombo = false
	$"../../Control/VBox/l_on_floor".set_text("")	


func _on_attack_0_area_entered(area: Area2D) -> void:
	power_modifer = int(player.velocity.x)
	power_modifer=power_modifer*-1 if power_modifer < 0 else power_modifer
	if not already_hit:
		print("first")
		if area.has_method("hit"):
			area.hit(Player.FIRST_ATTACK_MODIFICATOR + power_modifer)
		already_hit=true
