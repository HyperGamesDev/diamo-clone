extends CanvasLayer

@onready var progressBarFill_spr = load("res://UI/circleFill.png")
@onready var progressBarDecay_spr = load("res://UI/circleFillDecay.png")
@onready var scorePopup=$ScorePopup

func _ready():
	get_node("MultiplierProgressBar").max_value=Game.scoreMultiplierMaxTimer*10
	scorePopup.scale=Vector2.ZERO
	$GameOverUI.visible=false
	$GameOverUI/HighscoreTxt.text="Highscore: "+str(Game.highscore)


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
	
func score_popup_new(amnt,pos=Vector2(0,0),size=1):
	var scorePopupNew=scorePopup.duplicate()
	add_child(scorePopupNew)
	scorePopupNew.global_position=pos - scorePopupNew.pivot_offset
	scorePopupNew.scale=Vector2(size,size)
	scorePopupNew.text="+"+str(amnt)
	var tweenScale=get_tree().create_tween()
	tweenScale.tween_property(scorePopupNew,"scale",Vector2(size,size),0.25)
	tweenScale.tween_property(scorePopupNew,"scale",Vector2(0,0),0.15)
	tweenScale.tween_callback(scorePopupNew.queue_free)


func game_over():
	$GameOverUI.visible=true
	$GameOverUI/ScoreTxt.text="Score: "+str(Game.score)
	
func _on_restart_buton_pressed():
	Game.restart()
