extends Area2D

const SPEED=30

var point1=Vector2(0,0)
var point2=Vector2(0,0)

func _process(delta):
	var direction = (point2 - position).normalized()
	var velocity = direction * SPEED * delta
	
	if position.distance_to(point2) > velocity.length():
		position += velocity
	else:
		position = point2
		switch_points()

func switch_points():
	var pointTemp=point1
	point1=point2
	point2=pointTemp

func _on_area_entered(area):
	if(area.name=="Player"):
		Game.add_score(Game.scoreCollectable)
		Game.score_popup_new(Game.scoreCollectable,self.get_global_transform_with_canvas().origin,0.9)
		hide_point()
		if(Game.World_node.get_node("Collectables")!=null):
			Game.World_node.get_node("Collectables").reset_timer()
		else:
			print("Collectables node is null!")
	elif("Enemy" in area.name):
		hide_point()
		if(Game.World_node.get_node("Collectables")!=null):
			Game.World_node.get_node("Collectables").reset_timer()
		else:
			print("Collectables node is null!")
	
func hide_point():
	monitoring=false
	monitorable=false
	visible=false
	set_collision_mask_value(1,false)
	set_collision_mask_value(3,false)
	
func show_point():
	monitoring=true
	monitorable=true
	visible=true
	set_collision_mask_value(1,true)
	set_collision_mask_value(3,true)
	#restart_movement()
