extends CanvasLayer

@onready var progressBarFill_spr = load("res://circleFill.png")
@onready var progressBarDecay_spr = load("res://circleFillDecay.png")

func _ready():
	get_node("MultiplierProgressBar").max_value=Game.scoreMultiplierMaxTimer*10


func _process(delta):
	get_node("ScoreTxt").text="Score: "+str(Game.score)
	get_node("MultiplierProgressBar").value=Game.scoreMultiplierTimer*10
	get_node("MultiplierProgressBar/MultiplierTxt").text="x"+str(Game.scoreMultiplier)

func multiplier_progressing():
	get_node("MultiplierProgressBar").set_progress_texture(progressBarFill_spr)
	
func multiplier_decaying():
	get_node("MultiplierProgressBar").set_progress_texture(progressBarDecay_spr)
