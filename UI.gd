extends CanvasLayer

@onready var progressBarFill_spr = load("res://circleFill.png")
@onready var progressBarDecay_spr = load("res://circleFillDecay.png")
@onready var scorePopup=$ScorePopup

func _ready():
	get_node("MultiplierProgressBar").max_value=Game.scoreMultiplierMaxTimer*10
	scorePopup.scale=Vector2.ZERO


func _process(delta):
	get_node("ScoreTxt").text=str(Game.score)
	get_node("MultiplierProgressBar").value=Game.scoreMultiplierTimer*10
	get_node("MultiplierProgressBar/MultiplierTxt").text="x"+str(Game.scoreMultiplier)

func multiplier_progressing():
	get_node("MultiplierProgressBar").set_progress_texture(progressBarFill_spr)
	
func multiplier_decaying():
	get_node("MultiplierProgressBar").set_progress_texture(progressBarDecay_spr)

func score_popup(amnt):
	scorePopup.text="+"+str(amnt)
	var tweenScale=get_tree().create_tween()
	tweenScale.tween_property(scorePopup,"scale",Vector2(1,1),0.25)
	tweenScale.tween_property(scorePopup,"scale",Vector2(0,0),0.15)
