extends Area2D

const SPEED=30

var point1=Vector2(0,0)
var point2=Vector2(0,0)
var lineid=""
var move=true

func _process(delta):
	if(move):
		var direction = (point2 - position).normalized()
		var velocity = direction * SPEED * delta
		
		if position.distance_to(point2) > velocity.length():
			position += velocity
		else:
			position = point2
			switch_points()
	rotate(deg_to_rad(SPEED*360*delta*0.1))
	
	if(lineid!=""):
		if(is_on_disabled_line() and visible):
			hide_point()
			reset_timer()

func switch_points():
	var pointTemp=point1
	point1=point2
	point2=pointTemp

func _on_area_entered(area):
	if(area.name=="Player"):
		if("enemy" not in get_parent().name.to_lower() and "bullet" not in area.name.to_lower()):
			Game.add_score(Game.scoreCollectable,false)
			Game.score_popup_new(Game.scoreCollectable,self.get_global_transform_with_canvas().origin,0.9,false)
			hide_point()
			reset_timer()
		else:
			Game.add_score(Game.scoreCollectableEnemy,false)
			Game.score_popup_new(Game.scoreCollectableEnemy,self.get_global_transform_with_canvas().origin,0.9,false)
			get_parent().die()
	elif("enemy" in area.name.to_lower() or "bullet" in area.name.to_lower() and area!=get_parent()):
		if("enemy" not in get_parent().name.to_lower()):
			hide_point()
			if(Game.World_node.get_node("Collectables")!=null):
				Game.World_node.get_node("Collectables").reset_timer()
			else:
				print("Collectables node is null!")

func is_on_disabled_line()->bool:
	return !Game.World_node.lineconnections[lineid].enabled


func hide_point():
	visible=false
	monitoring=false
	monitorable=false
	set_collision_mask_value(1,false)
	set_collision_mask_value(3,false)
	
func show_point():
	visible=true
	monitoring=true
	monitorable=true
	set_collision_mask_value(1,true)
	set_collision_mask_value(3,true)
	#restart_movement()

func reset_timer():
	if(Game.World_node.get_node("Collectables")!=null):
		Game.World_node.get_node("Collectables").reset_timer()
	else:
		print("Collectables node is null!")
