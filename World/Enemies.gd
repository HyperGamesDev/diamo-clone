extends Node2D


@onready var enemyPrefabs=[
	{
		"prefab":preload("res://Enemies/enemy1.tscn"),
		"speed":20,
		"point_aligned":false,
		"point_req":0,
	},
	{
		"prefab":preload("res://Enemies/enemy2.tscn"),
		"speed":26,
		"point_aligned":false,
		"point_req":0,
	},
	{
		"prefab":preload("res://Enemies/enemy3.tscn"),
		"speed":14,
		"point_aligned":false,
		"point_req":0,
	},
	{
		"prefab":preload("res://Enemies/enemy4.tscn"),
		"speed":14,
		"point_aligned":true,
		"point_req":60,
	},
	{
		"prefab":preload("res://Enemies/enemy6.tscn"),
		"speed":20,
		"point_aligned":false,
		"point_req":150,
	},
]
const point_req=false##False just for testing
var enemiesInstances=[]
@onready var rng=RandomNumberGenerator.new()

const enemiesTimerMinMax=Vector2(2,4)

var boundary_rect
const DISTANCE_FROM_BOUNDARIES=20

func _ready():
	reset_timer()
	var boundary_rect_area = Game.World_node.get_node("BoundaryRectArea")
	var boundary_position = boundary_rect_area.global_position
	var boundary_size = boundary_rect_area.get_node("CollisionShape2D").shape.extents * 2.0

	boundary_rect = Rect2(boundary_position - boundary_size / 2, boundary_size)
	
func _process(delta):
	for enemy in enemiesInstances:
		if(enemy==null):
			enemiesInstances.erase(enemy)
	
func _on_enemies_timer_timeout():
	var enemyChoices=enemyPrefabs.duplicate()
	enemyChoices.shuffle()
#	while(enemyChoices[0]["point_req"]>Game.score and point_req):
#		enemyChoices.shuffle()
	for enemy in enemyChoices:
		if(enemy["point_req"]>Game.score and point_req):
			enemyChoices.erase(enemy)
	var enemyChoice=enemyChoices[0]
	
	var enemyInstance=enemyChoice["prefab"].instantiate()
	print(":")
	print(enemyChoice["prefab"].resource_path)
	print(enemyInstance.name)
	add_child(enemyInstance)
	enemyInstance.name=enemyChoice["prefab"].resource_path.split("Enemies/")[1].split("tscn")[0]
	print(enemyInstance.name)
	var point1=generate_random_enemy_position()
	if(enemyChoice["point_aligned"]):
		var point1id=generate_random_enemy4_pointid()
		point1=generate_random_enemy4_position(point1id)
		enemyInstance.set_point_rot(point1id)
	var point2=Game.World_node.pointpositions[0]
	enemyInstance.position=point1
	enemyInstance.point1=point1
	enemyInstance.point2=point2
	enemyInstance.speed=enemyChoice["speed"]
	enemiesInstances.append(enemyInstance)
	reset_timer()

func generate_random_enemy_position() -> Vector2:
	var enemy_position = Vector2.ZERO

	var edge = 1+randi() % 4  # Randomly choose an edge (0: top, 1: right, 2: bottom, 3: left)

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
	var rand_timer:float=rng.randi_range(enemiesTimerMinMax.x*10,enemiesTimerMinMax.y*10)/10.0
	$EnemiesTimer.start(rand_timer)
	#print($EnemiesTimer.wait_time)
