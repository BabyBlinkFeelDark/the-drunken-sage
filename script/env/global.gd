extends Node
signal catscene
signal player_can_fly
var player_hp
var player_st
var player_position
var player_velocity
var SCENE
var game_pause
@onready var player = $Player as Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SCENE = preload("res://scenes/levels/portal.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		game_pause =!game_pause
	pass

func go_to_tavern():
	var y
	y = player_position.y
	player_can_fly.emit("up",y)


	
func spawn_portal():
	var child
	child = SCENE.instantiate()
	child.position = player_position
	add_child(child)

func tp_tavern():
	get_tree().change_scene_to_file("res://scenes/levels/tavern.tscn")
