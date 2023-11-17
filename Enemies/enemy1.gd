extends Area2D

var speed=30

var point1=Vector2(0,0)
var point2=Vector2(0,0)

var nearmissed=false
var nearmissed_complete=false

func _ready():
	rotation=deg_to_rad(randi_range(0,360))

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
			
	rotate(deg_to_rad(speed/10*360*delta*0.6))


func _on_area_entered(area):
	if(area.name=="Player"):
		area.die()
		self.die()

func die():
	self.queue_free()
