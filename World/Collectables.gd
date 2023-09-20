extends Node2D


@onready var collectablePoint=preload("res://World/collectable_point.tscn")
var collectablePointInstance=null
@onready var rng=RandomNumberGenerator.new()

const collectablesTimerMinMax=Vector2(9,15)

func _ready():
	collectablePointInstance=collectablePoint.instantiate()
	add_child(collectablePointInstance)
	collectablePointInstance.hide_point()
	reset_timer()
	
func _on_collectables_timer_timeout():
	var point1id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	var point2id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	while ((point2id==point1id) or ((point1id==1 and point2id==3) or (point1id==4 and point2id==2) or (point2id==1 and point1id==3) or (point2id==4 and point1id==2))):
		point2id=rng.randi_range(0,len(Game.World_node.pointpositions)-1)
	var point1=Game.World_node.pointpositions[point1id]
	var point2=Game.World_node.pointpositions[point2id]
	var randomPoint = (point1 + (point2 - point1) * randf())
	
	collectablePointInstance.position=randomPoint
	collectablePointInstance.point1=point1
	collectablePointInstance.point2=point2
	collectablePointInstance.show_point()

func reset_timer():
	var rand_timer:float=rng.randi_range(collectablesTimerMinMax.x*10,collectablesTimerMinMax.y*10)/10.0
	$CollectablesTimer.wait_time=rand_timer
	$CollectablesTimer.start()
	#print($CollectablesTimer.wait_time)
