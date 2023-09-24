extends Line2D

var lineid="12"
var checked=false
var enabled=true

var point1:Vector2
var point2:Vector2
var middlepoint:Vector2


func setup(lineid_param:String,pos1:Vector2,pos2:Vector2,collidable:bool=true):
	lineid=lineid_param
	name="Line_"+lineid
	points=[]
	add_point(pos1)
	add_point(pos2)
	point1=pos1
	point2=pos2
	middlepoint=(point1+point2)/2
	
	var segment_shape = SegmentShape2D.new()
	segment_shape.a = point1
	segment_shape.b = point2
	$Area2D/CollisionShape2D.shape = segment_shape
	#$Area2D.scale=Vector2(0.32*self.width,1)
	
	if not collidable:
		$Area2D.monitoring=false
		$Area2D.monitorable=false
		$Area2D.collision_layer = 0
		$Area2D.collision_mask = 0
		$Area2D/CollisionShape2D.disabled=true
	

func _process(delta):
	var ratio=clamp(1-($EnableTimer.time_left/$EnableTimer.wait_time),0.0,1.0)
	
	points[0] = middlepoint + (point1 - middlepoint) * ratio
	points[1] = middlepoint + (point2 - middlepoint) * ratio
	
	if not enabled:
		checked=false

func set_checked():
	if(!checked):
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(self,"default_color",Game.World_node.lineColorChecked,0.05)
	checked=true
	
func reset_checked():
	if(checked):
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(self,"default_color",Color(0.6,0.6,0.6),0.05)
		tweenColor.tween_property(self,"default_color",Game.World_node.lineColor,0.05)
	checked=false

func finish_diamond_reset():
	var tweenColor=get_tree().create_tween()
	tweenColor.tween_property(self,"default_color",Color("#2bbd97"),0.05)
	tweenColor.tween_property(self,"default_color",Game.World_node.lineColor,0.1)
	
	checked=false


func disable_line():
	reset_checked()
#	Game.World_node.checkedlines.erase(lineid)
#	Game.World_node.checkedlines_new.erase(lineid)
	enabled=false
	$Area2D.monitoring=false
	$Area2D.monitorable=false
	$Area2D.collision_mask = 0
	$Area2D/CollisionShape2D.disabled=true
	$EnableTimer.wait_time=Game.World_node.line_enableTimerMax
	$EnableTimer.start()
	points[0]=middlepoint
	points[1]=middlepoint
	
func enable_line():
	enabled=true
	$Area2D.monitoring=true
	$Area2D.monitorable=true
	$Area2D.set_collision_mask_value(3,true)
	$Area2D/CollisionShape2D.disabled=false
	$EnableTimer.stop()


func _on_enable_timer_timeout():
	enable_line()

func _on_area_2d_area_entered(area):
	if("enemy5" in area.name):
		print()
		print("Collision with: "+self.lineid)
		Game.World_node.uncheck_line(self.lineid)
		self.disable_line()
		area.monitoring=false
		area.monitorable=false
		area.die()
