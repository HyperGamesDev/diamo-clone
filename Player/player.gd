extends Area2D

const SPEED = 1.5
const SPEED_CHECKED_LINE_MULT = 1.1
const SPEED_HOLD_MULT = 2

var speedcur=SPEED
var currentpos_id=0
var lastpos_id=0
var new_pos=position
var moving=false
var current_action=""
var movedFromLastDist=0

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
		speedcur=calculate_speed()
		movedFromLastDist=Game.World_node.pointpositions[lastpos_id].distance_to(position)
		
		rotate(deg_to_rad(speedcur*360*delta*1))
		tweenPos.set_speed_scale(speedcur)
		Game.progress_multiplier(delta,speedcur)
		
		if(is_on_disabled_line()):
			die()
	else:
		rotation=deg_to_rad(45)
		movedFromLastDist=0
		Game.decay_multiplier(delta)

func move_up():
	current_action="up"
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
	current_action="right"
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
	current_action="down"
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
	current_action="left"
	match (currentpos_id):
		0:
			change_posid(4)
		1:
			change_posid(4)
		2:
			change_posid(0)
		3:
			change_posid(4)

func any_button_pressed()->bool:
	return (Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("left"))

func change_posid(newid):
	#Game.World_node.checkif_line_enabled(lastpos_id,currentpos_id)
	if(Game.World_node.lineconnections[Game.World_node.get_lineid(currentpos_id,newid)].enabled):
		currentpos_id=newid
		moving=true
		new_pos=Game.World_node.pointpositions[currentpos_id]

		tweenPos=get_tree().create_tween()
		tweenPos.set_speed_scale(speedcur)
		tweenPos.tween_property(self,"position",new_pos,2)
		tweenPos.tween_callback(fill_line)

func calculate_speed()->float:
	var speedMult=1
	if(Input.is_action_pressed(current_action)):
		speedMult*=SPEED_HOLD_MULT
	if(is_on_checked_line()):
		speedMult*=SPEED_CHECKED_LINE_MULT
	
	#print(SPEED*speedMult)
	return SPEED*speedMult

func fill_line():
	var lineid=get_current_lineid()
	Game.World_node.check_line(lineid)
	moving=false

func is_on_checked_line()->bool:
	var lineid=get_current_lineid()
	return (lineid in Game.World_node.checkedlines)
	
func is_on_disabled_line()->bool:
	var lineid=get_current_lineid()
	return !Game.World_node.lineconnections[lineid].enabled

func get_current_lineid()->String:
	return Game.World_node.get_lineid(lastpos_id,currentpos_id)
	
	
func die():
	queue_free()
	Game.game_over()
	Game.Player_node=null
	if(Game.score>Game.highscore):
		Game.highscore=Game.score
	Utils.save_game()
