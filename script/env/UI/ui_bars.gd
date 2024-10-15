extends CanvasLayer
@onready var player_healthbar = $HeathBar 
@onready var player_ultabar = $UltaBar  
@onready var player_staminabar = $StaminaBar

@onready var player_stats={
	"Skills":{"Dash": $Dash,
			   "Ulta" : $UltaBar},
	
	"Stats" :{"Health" : $HeathBar,
			  "Stamina": $StaminaBar}
}


func _process(delta: float) -> void:
	
	if Global.player_hp:
		player_stats["Stats"]["Health"].value = Global.player_hp
	if owner:
		player_stats["Skills"]["Dash"].value=100-owner.cooldown_dash*200
		owner.stamina = player_stats["Stats"]["Stamina"].value
		owner.stamina_changet.connect(_stamina_changet)
	if player_staminabar.value <= 100:
		player_staminabar.value+=5*delta

func _stamina_changet(cost):

	player_staminabar.value-=cost
	
