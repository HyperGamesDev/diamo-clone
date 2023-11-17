extends Area2D

var speed=30

var point1=Vector2(0,0)
var point2=Vector2(0,0)

var nearmissed=false
var nearmissed_complete=false

var point_dir=1
var chance_to_rotate=45
var do_rotate_point=false
const point_rotate_speed=2.0
const point_rotate_radius=25.0
var d=0.0

func _ready():
	$CollectablePoint.show_point()
	$CollectablePoint.move=false
	if(randi_range(0,100)<chance_to_rotate):
		do_rotate_point=true

func _process(delta):
	var direction = (point2 - point1).normalized()

	position += direction * speed * delta * 5
	
	if(abs(position.x)>500 or abs(position.y)>500):
		self.queue_free()
		
	
	if(Game.Player_node):
		if(Game.Player_node.moving):##Check for nearmiss
			if(position.distance_to(Game.Player_node.position)<40 and Game.Player_node.movedFromLastDist>40):
				nearmissed=true
			if(position.distance_to(Game.Player_node.position)>50 and nearmissed and not nearmissed_complete):
				nearmissed_complete=true
				Game.add_score(Game.scoreNearMiss)
				Game.score_popup_new(Game.scoreNearMiss,self.get_global_transform_with_canvas().origin,0.9)
		else:
			nearmissed=false
	
	### SPECIFIC CODE ###
	#rotate(deg_to_rad(speed/10*360*delta*0.2))
	$Sprite2D_Inside1.rotate(deg_to_rad(speed/10*360*delta*0.2))
	$Sprite2D_Inside2.rotate(deg_to_rad(speed/10*360*delta*0.2)*-1)
	
	if(do_rotate_point):
		d+=delta
		$CollectablePoint.position=Vector2(
			sin(d*point_rotate_speed)*point_rotate_radius,
			cos(d*point_rotate_speed)*point_rotate_radius
		)


func _on_area_entered(area):
	if(area.name=="Player"):
		area.die()
		self.die()

func die():
	self.monitoring=false
	self.monitorable=false
	self.queue_free()

func set_point_rot(point_dir_param):
	point_dir=point_dir_param
	var initial_angle_degrees
	match point_dir:
		1: initial_angle_degrees=90	# Down
		2: initial_angle_degrees=180	# Right
		3: initial_angle_degrees=-90	# Up
		4: initial_angle_degrees=0	# Left
	var initial_angle_radians = deg_to_rad(initial_angle_degrees)
	$CollectablePoint.position = Vector2(
		cos(initial_angle_radians) * point_rotate_radius,
		sin(initial_angle_radians) * point_rotate_radius
	)
