# enemy.gd (abstract class)
class_name NPC
extends CharacterBody2D

var default_health: int = 100
var direction: Vector2
var alive: bool = true
var player: Player
var default_attack_cooldown: float = 2.0
var default_time_since_last_attack: float = 2.0
var type: String


func enemy_logic():
	pass
