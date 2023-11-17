extends Node2D


@onready var enemyPrefabs=[
	{
		"prefab":preload("res://Enemies/enemy1.tscn"),
		"speed":20,
		"point1_aligned":false,
		"nearest_point2":false,
		"score_req":0,
		"limit":0,
	},
	{
		"prefab":preload("res://Enemies/enemy2.tscn"),
		"speed":26,
		"point1_aligned":false,
		"nearest_point2":false,
		"score_req":0,
		"limit":0,
	},
	{
		"prefab":preload("res://Enemies/enemy3.tscn"),
		"speed":14,
		"point1_aligned":false,
		"nearest_point2":false,
		"score_req":0,
		"limit":0,
	},
	{
		"prefab":preload("res://Enemies/enemy4.tscn"),
		"speed":14,
		"point1_aligned":true,
		"nearest_point2":false,
		"score_req":60,
		"limit":2,
	},
	{
		"prefab":preload("res://Enemies/enemy5.tscn"),
		"speed":14,
		"point1_aligned":false,
		"nearest_point2":false,
		"score_req":80,
		"limit":-1,
	},
	{
		"prefab":preload("res://Enemies/enemy6.tscn"),
		"speed":20,
		"point1_aligned":false,
		"nearest_point2":false,
		"score_req":150,
		"limit":1,
	},
	{
		"prefab":preload("res://Enemies/enemy7.tscn"),
		"speed":20,
		"point1_aligned":false,
		"nearest_point2":true,
		"score_req":160,
		"limit":1,
	},
]
const score_req=false##False just for testing
var enemiesInstances=[]
@onready var rng=RandomNumberGenerator.new()

const enemiesTimerMinMax=Vector2(2,4)

var boundary_rect
const DISTANCE_FROM_BOUNDARIES=20

func _ready():
#	enemyPrefabs=[
#		{
#			"prefab":preload("res://Enemies/enemy7.tscn"),
#			"speed":20,
#			"point1_aligned":false,
#			"nearest_point2":true,
#			"score_req":160,
#			"limit":1,
#		},
#	]
#	enemiesTimerMinMax=Vector2(0.1,0.1)
	reset_timer()
	var boundary_rect_area = Game.World_node.get_node("BoundaryRectArea")
	var boundary_position = boundary_rect_area.global_position
	var boundary_size = boundary_rect_area.get_node("CollisionShape2D").shape.extents * 2.0

	boundary_rect = Rect2(boundary_position - boundary_size / 2, boundary_size)
	
func _process(_delta):
	for enemy in enemiesInstances:
		if(enemy==null):
			enemiesInstances.erase(enemy)
	
func _on_enemies_timer_timeout():
	var enemyChoices=enemyPrefabs.duplicate()
	enemyChoices.shuffle()
	for enemy in enemyChoices:
		var enemyname=enemy["prefab"].resource_path.split("Enemies/")[1].split(".tscn")[0]
		var enemylength=Utils.find_nodes_with_string(self,enemyname).size()
		var enemyMaxLength=enemy["limit"]
		if((enemy["score_req"]>Game.score and score_req) or (enemylength>=enemyMaxLength and enemyMaxLength!=0)):
			enemyChoices.erase(enemy)
	if(enemyChoices.size()>0):
		var enemyChoice=enemyChoices[0]
		
		var enemyInstance=enemyChoice["prefab"].instantiate()
		add_child(enemyInstance)
		enemyInstance.name=enemyChoice["prefab"].resource_path.split("Enemies/")[1].split("tscn")[0]
		var point1_edgeid=generate_random_enemy_edgeid()
		var point1=generate_random_enemy_edgepos(point1_edgeid)
		if(enemyChoice["point1_aligned"]):
			var point1id=generate_random_enemy4_pointid()
			point1=generate_random_enemy4_position(point1id)
			enemyInstance.set_point_rot(point1id)
		var point2=Game.World_node.pointpositions[0]
		if(enemyChoice["nearest_point2"]):
			point2=Game.World_node.pointpositions[point1_edgeid]
			enemyInstance.point1start_id=point1_edgeid
		enemyInstance.position=point1
		enemyInstance.point1=point1
		enemyInstance.point2=point2
		enemyInstance.speed=enemyChoice["speed"]
		enemiesInstances.append(enemyInstance)
	else:
		print("enemyChoices length is 0!")
	reset_timer()

func generate_random_enemy_edgeid()->int:
	return 1+randi() % 4 # (0: top, 1: right, 2: bottom, 3: left)

func generate_random_enemy_edgepos(edge) -> Vector2:
	var enemy_position = Vector2.ZERO

	match edge:
		1:  # Top edge
			enemy_position.x = rng.randi_range(boundary_rect.position.x, boundary_rect.position.x + boundary_rect.size.x)
			enemy_position.y = boundary_rect.position.y - randi() % DISTANCE_FROM_BOUNDARIES
		2:  # Right edge
			enemy_position.x = boundary_rect.position.x + boundary_rect.size.x + randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = rng.randi_range(boundary_rect.position.y, boundary_rect.position.y + boundary_rect.size.y)
		3:  # Bottom edge
			enemy_position.x = rng.randi_range(boundary_rect.position.x, boundary_rect.position.x + boundary_rect.size.x)
			enemy_position.y = boundary_rect.position.y + boundary_rect.size.y + randi() % DISTANCE_FROM_BOUNDARIES
		4:  # Left edge
			enemy_position.x = boundary_rect.position.x - randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = rng.randi_range(boundary_rect.position.y, boundary_rect.position.y + boundary_rect.size.y)

	return enemy_position

func generate_random_enemy4_pointid()->int:
	return 1+randi() % 4#len(Game.World_node.pointpositions)-2##Minus the 0 point

func generate_random_enemy4_position(pointid) -> Vector2:
	var enemy_position = Vector2.ZERO

	match pointid:
		1:  # Top
			enemy_position.x = Game.World_node.pointpositions[1].x
			enemy_position.y = boundary_rect.position.y - randi() % DISTANCE_FROM_BOUNDARIES
		2:  # Right
			enemy_position.x = boundary_rect.position.x + boundary_rect.size.x + randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = Game.World_node.pointpositions[2].y
		3:  # Bottom
			enemy_position.x = Game.World_node.pointpositions[3].x
			enemy_position.y = boundary_rect.position.y + boundary_rect.size.y + randi() % DISTANCE_FROM_BOUNDARIES
		4:  # Left
			enemy_position.x = boundary_rect.position.x - randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = Game.World_node.pointpositions[4].y

	return enemy_position

func reset_timer():
	@warning_ignore("narrowing_conversion")
	var rand_timer:float=rng.randi_range(enemiesTimerMinMax.x*10,enemiesTimerMinMax.y*10)/10.0
	$EnemiesTimer.stop()
	$EnemiesTimer.start(rand_timer)
