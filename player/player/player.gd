class_name Player
extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
const FIRST_ATTACK_MODIFICATOR = 30
const SECOND_ATTACK_MODIFICATOR = 50
const TRIRD_ATTACK_MODIFICATOR = 70
const DASH_MODIFICATOR = 5
const COLDDOWN_DASH = 0.5

signal u_turn

@onready var anim = $AnimatedSprite2D 
@onready var anim_fx = $AnimatedSprite2_efx
@onready var anim_pl = $AnimationPlayer
var jump_counter = 0
var canCombo = false
var canDash: bool = true


#@onready var zones = $Zones
@onready var first_attack_zone=$Zones/Attack_0
@onready var second_attack_zone=$Zones/Attack_1
@onready var third_attack_zone=$Zones/Attack_2
