extends Area2D

var speed=30

var point1=Vector2(0,0)
var point2=Vector2(0,0)

func _ready():
	rotation=deg_to_rad(randi_range(0,360))

func _process(delta):
	var direction = (point2 - point1).normalized()
	var extended_direction = direction * 5

	position += extended_direction * speed * delta
	
	if(abs(position.x)>500 or abs(position.y)>500):
		self.queue_free()
		
	rotate(deg_to_rad(speed/10*360*delta*0.6))


func _on_area_entered(area):
	if(area.name=="Player"):
		area.queue_free()
		Game.gameover=true
		self.queue_free()
	elif(area.name=="CollectablePoint"):
		area.hide_point()
		self.queue_free()
