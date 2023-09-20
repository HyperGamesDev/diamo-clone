extends CharacterBody2D

const SPEED = 2
const SPEED_HOLD = 3.5

var speedcur=SPEED
var currentpos_id=0
var lastpos_id=0
var new_pos=position
var moving=false

@onready var tweenPos: Tween=get_tree().create_tween()

func _ready():
	pass
	#position=get_node("World").pointpositions[currentpos_id]

func _process(delta):
	if !moving:
		lastpos_id=currentpos_id
		match (currentpos_id):
			0:
				if(Input.is_action_pressed("up")):
					change_posid(1)
				elif(Input.is_action_pressed("right")):
					change_posid(2)
				elif(Input.is_action_pressed("down")):
					change_posid(3)
				elif(Input.is_action_pressed("left")):
					change_posid(4)
			1:
				if(Input.is_action_pressed("right")):
					change_posid(2)
				elif(Input.is_action_pressed("down")):
					change_posid(0)
				elif(Input.is_action_pressed("left")):
					change_posid(4)
			2:
				if(Input.is_action_pressed("up")):
					change_posid(1)
				elif(Input.is_action_pressed("down")):
					change_posid(3)
				elif(Input.is_action_pressed("left")):
					change_posid(0)
			3:
				if(Input.is_action_pressed("up")):
					change_posid(0)
				elif(Input.is_action_pressed("right")):
					change_posid(2)
				elif(Input.is_action_pressed("left")):
					change_posid(4)
			4:
				if(Input.is_action_pressed("up")):
					change_posid(1)
				elif(Input.is_action_pressed("right")):
					change_posid(0)
				elif(Input.is_action_pressed("down")):
					change_posid(3)
	if moving:
		if(any_button_pressed()):
			speedcur=SPEED_HOLD
		else:
			speedcur=SPEED
		
		tweenPos.set_speed_scale(speedcur)
		Game.progress_multiplier(delta,speedcur)
	else:
		rotation=45
		Game.decay_multiplier(delta)
		
func any_button_pressed():
	return (Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("left"))

func change_posid(id):
	currentpos_id=id
	moving=true
	new_pos=Game.World_node.pointpositions[currentpos_id]

	tweenPos=get_tree().create_tween()
	tweenPos.set_speed_scale(speedcur)
	tweenPos.tween_property(self,"position",new_pos,2)
	tweenPos.tween_callback(fill_line)

func fill_line():
	var lineid=str(lastpos_id)+str(currentpos_id)
	if(!Game.World_node.lineconnections.has(lineid)):
		lineid=str(currentpos_id)+str(lastpos_id)## Reverse the string
	Game.World_node.check_line(lineid)
	rotation=45
	moving=false
