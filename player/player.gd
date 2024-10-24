extends Player
class_name StateMachine


func _process(delta: float) -> void:

	"""
	Обновляет состояние игрока каждый кадр.
  
	Отображает текущее здоровье игрока на UI и обновляет глобальные параметры игрока.
  
	:param delta: Время, прошедшее с последнего кадра.
	"""
	$Label.set_text(str(health))
	del = delta 
	Global.player_velocity = velocity
	Global.player_position = global_position
	Global.player_can_fly.connect(_on_catscene)


# Метод, вызываемый каждый кадр в физическом процессе.
func _physics_process(delta: float) -> void:
	"""
	Обрабатывает физику движения персонажа.

	Управляет звуковыми эффектами при движении и переключает состояния персонажа в зависимости от текущего состояния.

	:param delta: Время, прошедшее с последнего кадра.
	"""

 	# Звук при ходьбе
	if velocity.length() > 0 and is_on_floor():
		if not footstep_sound.playing:
			footstep_sound.play()
	else:
		footstep_sound.stop()
	if cooldown_dash<0.5:
			cooldown_dash+=get_process_delta_time()
	else:
		cooldown_dash=0.5
	$Pivot/Camera2D.position_smoothing_enabled=true
	# Переключение состояний персонажа
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
		TELEPORT:
			teleport_state()
		ULTA:
			ulta_state()

	if not is_on_floor():
		velocity.y += get_gravity().y * delta


# Метод для состояния WALK.
func walk_state(vel_del):
	"""
	Обрабатывает состояние ходьбы персонажа.
  
	Персонаж движется влево или вправо, проигрывает соответствующую анимацию и проверяет условия для перехода в другие состояния.
  
	:param vel_del: Время, прошедшее с последнего кадра (не используется в данном методе).
	"""
	move_and_slide()

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
	# Сигналы о направлении взгляда персонажа	
	if direction == -1:
		u_turn.emit("left")
		anim.flip_h=true

	elif direction == 1:
		u_turn.emit("right")	
		anim.flip_h=false
	
	# Логика проверкии условий состояния
	if Input.is_action_just_pressed("dash"):
		time_to_signal=true
		state=DASH
	if Input.is_action_just_pressed("jump") and jump_scale<3:
		state = JUMP
	#if Input.is_action_just_pressed("LMB"):
		#state=ULTA
	if not is_on_floor():
		state = FALL
	if health<=0:
		state=DEATH


# Метод для состояния JUMP.
func jump_state():
	"""
	Обрабатывает состояние прыжка персонажа.
  
	Персонаж выполняет прыжок, проигрывает соответствующую анимацию и изменяет состояние на FALL после прыжка.
	"""
	# Персонаж совершает прыжок
	move_and_slide()
	jump_sound.play()	
	if jump_scale<3:
		jump_scale+=1
		#velocity = Vector2.ZERO
		velocity.y = JUMP_VELOCITY
		anim_player.play("Jump")
		
	state=FALL


# Метод для состояния DASH.
func dash_state(vel):
	"""
	Обрабатывает состояние рывка персонажа.
  
	Проверяет условия для выполнения рывка, проигрывает соответствующую анимацию 
	и изменяет состояние обратно на WALK или FALL в зависимости от положения персонажа.
  
	:param vel: Время, прошедшее с последнего кадра (не используется в данном методе).
	"""
	move_and_slide()
	
	dash_duration+=get_process_delta_time()
	$HitBoxs/DashHitBox.set_monitoring(true)
	if cooldown_dash == 0.5 and stamina > dash_cost and dash_duration<DEFAULT_DASH_DURATION:
		
		if time_to_signal:
			stamina_changet.emit(dash_cost)
			time_to_signal=false

			
		var direction := Input.get_axis("left", "right")
		$PointLight2D.energy = lerpf(2, 0, 0.1)
	
		if direction!= 0:
			anim_player.play("Dash")
			$Pivot.position.x = 150 * direction
			velocity.x += (50 * direction)
			velocity.y = 0
			await anim_player.animation_finished
			cooldown_dash = 0
	dash_duration = 0
		
	$HitBoxs/DashHitBox.set_monitoring(false)
	if not is_on_floor():
		state = FALL
	else:
		state=WALK


func climb_state():
	var direction := Input.get_axis("left", "right")


# Метод для состояния DAMAGE.
func damage_state():
	"""
	Обрабатывает состояние получения урона персонажем.
  
	Обновляет здоровье игрока и проигрывает анимацию получения урона, после чего возвращает состояние к WALK.
	"""
	# Персонаж получает урон. Обновляем глобальную переменую количество 'health' персонажа
	Global.player_hp = health
	#print("oooooatch")
	#anim_player.play("damage")
	#await anim_player.animation_finished
	state = WALK
	pass


# Метод для состояния FALL.
func fall_state():
	"""
	Обрабатывает состояние падения персонажа.
  
	Персонаж не находится на земле и проигрывает анимацию падения. 
	Управляет движением влево и вправо, а также проверяет условия для перехода обратно в состояние WALK или JUMP.
	"""
	anim_player.play("Fall")
	move_and_slide()
	$PointLight2D.energy = 0
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED #* del
		
	if direction == -1:
		u_turn.emit("left")
		anim.flip_h=true

	elif direction == 1:
		u_turn.emit("right")	
		anim.flip_h=false
			
	if is_on_floor():
		jump_scale=0
		state=WALK

	if Input.is_action_just_pressed("jump") and jump_scale<3:
		state=JUMP
	elif Input.is_action_just_pressed("dash"):
		time_to_signal=true
		state=DASH


# Метод для состояния DEATH.
func death_state():
	"""
	Обрабатывает состояние смерти персонажа.
  
	Если здоровье персонажа достигает нуля, проигрывается анимация смерти,
	и персонаж удаляется из мира. После этого происходит переход на экран меню.
"""
	if health<=0:
		health=0
		anim_player.play("death")
		await anim_player.animation_finished
		queue_free()
		get_tree(). change_scene_to_file("res://scene/menu.tscn")


# Метод для состояния TELEPORT
func teleport_state():
	"""
	Обрабатывает состояние телепортации персонажа.
  
	Персонаж перемещается вверх до заданной целевой позиции, 
	затем останавливается и вызывает создание портала.
	"""
	
	if position.y>=target_position:
		move_and_slide()
		velocity.y = JUMP_VELOCITY * del *20
	else:
		velocity.y=0
		Global.spawn_portal()

	
func ulta_state():
	if $CanvasLayer.player_stats["Skills"]["Ulta"].value==100:
		
		UltaAttackArea.set_monitoring(true)
		dont_move.emit(true)
		anim_player.play("Ulta")
		await anim_player.animation_finished
		$CanvasLayer.player_stats["Skills"]["Ulta"].value=0
	state=WALK
 

# Метод, обрабатывающий начало кат-сцены.
func _on_catscene(start_point,y):
	"""
	Устанавливает целевую позицию для телепортации в зависимости от точки начала кат-сцены.
  
	:param start_point: Направление начала кат-сцены ("up", "down", и т.д.).
	:param y: Координата Y, определяющая целевую позицию.
	"""
	if start_point == "up":
		target_position = y - 50
		state=TELEPORT


# Метод, обрабатывающий получение урона персонажем.
func _on_damage_receive(enemy_damage):
	"""
	Обрабатывает получение урона от врага.
  
	Уменьшает здоровье персонажа на величину полученного урона и изменяет состояние на DAMAGE.
  
	:param enemy_damage: Значение урона, полученное от врага.
	"""
	health-=enemy_damage
	state=DAMAGE


func _on_dash_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(DEFAULT_DAMAGE)

	pass # Replace with function body.
