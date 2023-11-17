extends Area2D

var speed=20

var point1start_id=1
var point1=Vector2(0,0)
var point2=Vector2(0,0)

var nearmissed=false
var nearmissed_complete=false

const balls_rotate_speed=4.0
const balls_rotate_radiusStart=20.0
var balls_rotate_radius=balls_rotate_radiusStart
var d=0.0

var bulletsShot=false

func _ready():
	var direction = (point2 - point1).normalized()
	look_at(position+direction)

func _process(delta):
	var direction = (point2 - point1).normalized()
	
	if position.distance_to(point2) > 2:
		position += direction * speed * delta * 5
	else:
		if($ShootTimer.is_stopped() and not bulletsShot):
			$ShootTimer.start()
	
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
	if(not bulletsShot):
		d+=delta
		$Bullet1.position=Vector2(
			sin(d*balls_rotate_speed)*balls_rotate_radius,
			cos(d*balls_rotate_speed)*balls_rotate_radius
		)
		$Bullet2.position=Vector2(
			sin(d*balls_rotate_speed)*balls_rotate_radius*-1,
			cos(d*balls_rotate_speed)*balls_rotate_radius*-1
		)
		
		if(not $ShootTimer.is_stopped()):
			var size = clamp(0.8 + (1 - $ShootTimer.time_left / $ShootTimer.wait_time), 1.0, 1.8)
			#print(str($ShootTimer.time_left)+" | "+str($ShootTimer.wait_time))
			$Sprite2D.scale=Vector2(size,size)
			
			balls_rotate_radius = clamp(balls_rotate_radiusStart * ($ShootTimer.time_left / $ShootTimer.wait_time), 1.0, balls_rotate_radiusStart)
	else:
#		var rotated_vector_ball1 = position.rotated(deg_to_rad(60))
#		var direction_ball1 = (rotated_vector_ball1 - position).normalized()
#		if $Bullet1.position.distance_to(rotated_vector_ball1) > 2:
#			$Bullet1.position += direction_ball1 * speed * delta * 5
		
		var ball1_endpos=Game.World_node.pointpositions[Game.World_node.get_point_to_the_left(point1start_id)]
		var direction_ball1 = (ball1_endpos - position).normalized()
		if $Bullet1.position.distance_to(ball1_endpos) > 2:
			$Bullet1.position += direction_ball1 * speed*1.5 * delta * 5
		
		var ball2_endpos=Game.World_node.pointpositions[Game.World_node.get_point_to_the_right(point1start_id)]
		var direction_ball2 = (ball2_endpos - position).normalized()
		if $Bullet2.position.distance_to(ball2_endpos) > 2:
			$Bullet2.position += direction_ball2 * speed*1.5 * delta * 5
			

func _on_area_entered(area):
	if(area.name=="Player"):
		area.die()

func die():
	self.queue_free()

func shoot():
	bulletsShot=true
	$Sprite2D.scale=Vector2.ZERO

func _on_shoottimer_timeout():
	self.shoot()
