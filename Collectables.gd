extends Node2D


@onready var collectablePoint=preload("res://collectable_point.tscn")
var collectablePointInstance=null
@onready var rng=RandomNumberGenerator.new()

func _ready():
	collectablePointInstance=collectablePoint.instantiate()
	add_child(collectablePointInstance)
	collectablePointInstance.hide_point()
	reset_timer()
	
func _on_collectables_timer_timeout():
	#var randlineid=Game.World_node.lineconnections.keys().randomize()[0]
	var point1id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	var point2id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	while (point2id==point1id):
		point2id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	var point1=Game.World_node.pointpositions[point1id]
	var point2=Game.World_node.pointpositions[point2id]
	var randomPoint = (point1 + (point2 - point1) * randf())
#	var rand_x=rng.randi_range(point1.x,point2.x)
#	var rand_y=rng.randi_range(point1.y,point2.y)
#	collectablePointInstance.position=Vector2(rand_x,rand_y)
	collectablePointInstance.position=randomPoint
	collectablePointInstance.point1=point1
	collectablePointInstance.point2=point2
	collectablePointInstance.show_point()
	print("Timeout")
	#reset_timer()

func reset_timer():
	var rand_timer:float=rng.randi_range(90,150)/10.0
	$CollectablesTimer.wait_time=rand_timer
	$CollectablesTimer.start()
	print($CollectablesTimer.wait_time)
