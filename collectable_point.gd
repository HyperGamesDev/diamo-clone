extends Area2D

var point1=Vector2(0,0)
var point2=Vector2(0,0)
const SPEED=30

#@onready var tweenPos=get_tree().create_tween()

#func _ready():
#	pass
#	##Move between points
#	#position=Tween.interpolate_value(point1,point2,5*delta)
#	#restart_movement()
#
#func restart_movement():
#	tweenPos.kill()
#	tweenPos=get_tree().create_tween()
#	tweenPos.tween_property(self,"position",point2,5)
#	tweenPos.tween_callback(restart_movement)
#	switch_points()

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
	
func show_point():
	monitoring=true
	monitorable=true
	visible=true
	set_collision_mask_value(1,true)
	#restart_movement()
