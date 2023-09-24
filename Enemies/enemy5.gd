extends Area2D

var speed=20

var point1=Vector2(0,0)
var point2=Vector2(0,0)

var nearmissed=false
var nearmissed_complete=false

func _ready():
	point2=Game.World_node.pointpositions[0]##The middle
	var direction = (point2 - point1).normalized()
	look_at(position+direction)

func _process(delta):
	var direction = (point2 - point1).normalized()
	var extended_direction = direction * 5

	position += extended_direction * speed * delta
	
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


func _on_area_entered(area):
	if(area.name=="Player"):
		area.die()
		#self.die()

func die():
	self.queue_free()

func _on_decaytimer_timeout():
	self.die()
