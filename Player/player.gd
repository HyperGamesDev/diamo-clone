extends Area2D

const SPEED = 1.5
const SPEED_HOLD = 3

var speedcur=SPEED
var currentpos_id=0
var lastpos_id=0
var new_pos=position
var moving=false

@onready var tweenPos: Tween=get_tree().create_tween()

func _process(delta):
	if !moving:
		lastpos_id=currentpos_id
		if(Input.is_action_pressed("up")):
			move_up()
		elif(Input.is_action_pressed("right")):
			move_right()
		elif(Input.is_action_pressed("down")):
			move_down()
		elif(Input.is_action_pressed("left")):
			move_left()
			
	if moving:
		if(any_button_pressed()):
			speedcur=SPEED_HOLD
		else:
			speedcur=SPEED
		
		rotate(deg_to_rad(speedcur*360*delta*1))
		tweenPos.set_speed_scale(speedcur)
		Game.progress_multiplier(delta,speedcur)
	else:
		rotation=deg_to_rad(45)
		Game.decay_multiplier(delta)

func move_up():
	match (currentpos_id):
		0:
			change_posid(1)
		2:
			change_posid(1)
		3:
			change_posid(0)
		4:
			change_posid(1)
			
func move_right():
	match (currentpos_id):
		0:
			change_posid(2)
		1:
			change_posid(2)
		3:
			change_posid(2)
		4:
			change_posid(0)
			
func move_down():
	match (currentpos_id):
		0:
			change_posid(3)
		1:
			change_posid(0)
		2:
			change_posid(3)
		4:
			change_posid(3)
			
func move_left():
	match (currentpos_id):
		0:
			change_posid(4)
		1:
			change_posid(4)
		2:
			change_posid(0)
		3:
			change_posid(4)

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
