extends Node
@onready var pause_menu = $PauseMenu
var game_pause_menu: bool = false
@onready var UI = $"../Player/UI_Bars"


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		game_pause_menu = !game_pause_menu
	if game_pause_menu == true:
		$PauseMenu.continue_pressed.connect(_on_continue_pressed)
		get_tree().paused = true
		UI.visible = false
		pause_menu.show()
	else:
		UI.visible = true
		pause_menu.hide()
		get_tree().paused = false
		
func _on_continue_pressed(paused):
	game_pause_menu=!paused
