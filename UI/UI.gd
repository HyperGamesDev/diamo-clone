extends CanvasLayer

@onready var progressBarFill_spr = load("res://UI/circleFill.png")
@onready var progressBarDecay_spr = load("res://UI/circleFillDecay.png")
@onready var scorePopup=$ScorePopups/ScorePopup

func _ready():
	$MultiplierProgressBar.max_value=Game.scoreMultiplierMaxTimer*10
	scorePopup.scale=Vector2.ZERO
	$GameOverUI.visible=false
	$GameOverUI/HighscoreTxt.text="Highscore: "+str(Game.highscore)##Set highscore txt before it overrides after deat
	$PauseUI.visible=false


func _process(delta):
	$ScoreTxt.text=str(Game.score)
	$MultiplierProgressBar.value=Game.scoreMultiplierTimer*10
	$MultiplierProgressBar/MultiplierTxt.text="x"+str(Game.scoreMultiplier)
	
	if(Input.is_action_just_pressed("pause")):
		if !Game.isgameover:
			if(get_tree().paused):
				resume()
			else:
				pause()
		else:
			get_tree().quit()
	if(Input.is_key_pressed(KEY_SPACE)):
		if(get_tree().paused):
			resume()
		if(Game.isgameover):
			resume()
			Game.restart()
			

func multiplier_progressing():
	$MultiplierProgressBar.set_progress_texture(progressBarFill_spr)
	
func multiplier_decaying():
	$MultiplierProgressBar.set_progress_texture(progressBarDecay_spr)

func score_popup(amnt):
	scorePopup.text="+"+str(amnt)
	var tweenScale=get_tree().create_tween()
	tweenScale.tween_property(scorePopup,"scale",Vector2(1,1),0.25)
	tweenScale.tween_property(scorePopup,"scale",Vector2(0,0),0.15)
	
func score_popup_new(amnt,pos=Vector2(0,0),size=1):
	var scorePopupNew=scorePopup.duplicate()
	$ScorePopups.add_child(scorePopupNew)
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
	
func pause():
	$PauseUI.visible=true
	get_tree().paused = true
	
func resume():
	$PauseUI.visible=false
	get_tree().paused = false
	
func restart():
	resume()
	Game.restart()
	
func _on_restart_buton_pressed():
	restart()
	
func _on_resume_button_pressed():
	resume()

func _on_quit_button_pressed():
	get_tree().quit()
