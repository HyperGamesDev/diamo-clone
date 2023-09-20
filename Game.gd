extends Node

var World_node=null
var UI_node=null

var score:int=0
var highscore:int=0

var scoreMultiplier:int=1
const scoreForDiamond:int=5
const scoreCollectable:int=1
const scoreMultiplierMax:int=5
var scoreMultiplierTimer:float=0
const scoreMultiplierMaxTimer:float=20
const scoreMultiplierDecaySpeed:float=10.5
var scoreMultiplierDecayDelay:float=0
const scoreMultiplierDecayDelaySet:float=0.33

func _ready():
	World_node = get_node("/root/World")
	UI_node = get_node("/root/World/UI")

func _process(delta):
	if(scoreMultiplierTimer>=scoreMultiplierMaxTimer and scoreMultiplier<scoreMultiplierMax):
		scoreMultiplierTimer=0
		scoreMultiplier+=1
	if(scoreMultiplier==scoreMultiplierMax):
		scoreMultiplierTimer=scoreMultiplierMaxTimer

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
	UI_node.score_popup(amnt)
