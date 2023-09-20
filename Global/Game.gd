extends Node

@onready var World_node = get_node("/root/World")
@onready var UI_node = get_node("/root/World/UI")

var score:int=0
var highscore:int=0
var gameover:bool=false

var scoreMultiplier:int=1
const scoreForDiamond:int=5
const scoreCollectable:int=1
const scoreMultiplierMax:int=5

var scoreMultiplierTimer:float=0
const scoreMultiplierMaxTimer:float=20
const scoreMultiplierDecaySpeed:float=10.5
var scoreMultiplierDecayDelay:float=0
const scoreMultiplierDecayDelaySet:float=0.33

func _process(delta):
	if(scoreMultiplierTimer>=scoreMultiplierMaxTimer and scoreMultiplier<scoreMultiplierMax):
		scoreMultiplierTimer=0
		scoreMultiplier+=1
	if(scoreMultiplier==scoreMultiplierMax):
		scoreMultiplierTimer=scoreMultiplierMaxTimer
	
#	if(Input.is_key_pressed(KEY_R)):
#		get_tree().reload_current_scene()
	if(Input.is_key_pressed(KEY_F11)):
		var current_mode = DisplayServer.window_get_mode()
		if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	

func progress_multiplier(delta,speed):
	UI_node.multiplier_progressing()
	if(scoreMultiplierTimer<scoreMultiplierMaxTimer):
		scoreMultiplierTimer+=speed*delta
	scoreMultiplierDecayDelay=scoreMultiplierDecayDelaySet
		
func decay_multiplier(delta):
	if scoreMultiplierDecayDelay>0:
		scoreMultiplierDecayDelay-=delta
	else:
		UI_node.multiplier_decaying()
		if scoreMultiplierTimer<=0:
			if(scoreMultiplier>1):
				scoreMultiplier-=1
				scoreMultiplierTimer=scoreMultiplierMaxTimer
			else:
				scoreMultiplierTimer=0
		if scoreMultiplierTimer>0:
			scoreMultiplierTimer-=scoreMultiplierDecaySpeed*delta
			if(scoreMultiplier==scoreMultiplierMax):
				scoreMultiplier-=1

func add_score(amnt):
	amnt*=scoreMultiplier
	score+=amnt

func score_popup(amnt):
	UI_node.score_popup(amnt*scoreMultiplier)
	
func score_popup_new(amnt,pos,size):
	UI_node.score_popup_new(amnt*scoreMultiplier,pos,size)