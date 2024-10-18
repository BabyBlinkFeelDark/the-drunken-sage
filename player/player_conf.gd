extends CharacterBody2D
class_name Player


# Перечисление состояний персонажа.
enum {
	WALK,
	DEATH,
	JUMP,
	FALL,
	CLIMB,
	ATTACK,
	DASH,
	TELEPORT,
	ULTA,
	DAMAGE
}
												# Константы
# Статы
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const DEFAULT_DAMAGE = 10


# Скиллы
const DEFAULT_DASH_COOLDOWN = 0.5
const DEFAULT_DASH_COST = 10
const JUMP_COUNT = 3
const DEFAULT_DASH_DURATION = 0.3
												# Основные переменные

# Узлы
@onready var anim = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var DashAttackArea =$HitBoxs/DashHitBox
@onready var UltaAttackArea =$HitBoxs/Ulta
@onready var npc: NPC

# Разрешающие
var is_catscene: bool
var start_catscene: bool
var time_to_signal: bool = false

# Статы
var health = 100
var stamina #
var ulta #
var dash_cost = 10
var cooldown_dash = 0
var jump_scale = 0 
var dash_duration = 0

# Звуки
var footstep_sound: AudioStreamPlayer2D
var jump_sound: AudioStreamPlayer2D

# Локальные
var state 
var start_point
var target_position 
var del

# Сигналы
signal u_turn
signal stamina_changet
signal ulta_changet
signal dont_move

# Метод, вызываемый при инициализации узла.
func _ready() -> void:
	"""
	Инициализация параметров игрока и подключение сигналов.
  
	Устанавливает начальное состояние персонажа в WALK, инициализирует звуковые эффекты и подключает сигнал для получения урона.
	"""

	$EFX.visible=false
	footstep_sound = $Running
	jump_sound = $Jump
	DashAttackArea.visible = false
	UltaAttackArea.visible = false
	state = WALK
	Global.connect("enemy_attack",Callable(self, "_on_damage_receive"))
	Global.player_hp=health
	$HitBoxs/DashHitBox.set_monitoring(false)
	pass
