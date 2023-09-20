extends Node2D


#@onready var enemy1=preload("res://Enemies/enemy1.tscn")
@onready var enemyPrefabs=[
	{
		"prefab":preload("res://Enemies/enemy1.tscn"),
		"speed":20,
	},
	{
		"prefab":preload("res://Enemies/enemy2.tscn"),
		"speed":26,
	},
	{
		"prefab":preload("res://Enemies/enemy3.tscn"),
		"speed":14,
	}
]
var enemiesInstances=[]
@onready var rng=RandomNumberGenerator.new()

#var camera_view_rect
var boundary_rect
const enemiesTimerMinMax=Vector2(7,9)
const DISTANCE_FROM_BOUNDARIES=20

func _ready():
	reset_timer()
	var boundary_rect_area=Game.World_node.get_node("BoundaryRectArea")
	var boundary_position = boundary_rect_area.global_position
	var boundary_size = boundary_rect_area.get_node("CollisionShape2D").shape.extents * 2.0

	boundary_rect = Rect2(boundary_position - boundary_size / 2, boundary_size)
	print(boundary_rect)
	#camera_view_rect=Game.World_node.get_node("Camera2D").rect
	#camera_view_rect = Rect2(Game.World_node.get_node("Camera2D").rect_position, Game.World_node.get_node("Camera2D").rect_size)
	
func _process(delta):
	for enemy in enemiesInstances:
		if(enemy==null):
			enemiesInstances.erase(enemy)
	
func _on_enemies_timer_timeout():
	var enemyChoices=enemyPrefabs.duplicate()
	enemyChoices.shuffle()
	var enemyPrefab=enemyChoices[0]["prefab"]
#	var enemyChoice=enemyPrefabs.keys().duplicate().randomize()[0]
#	var enemyPrefab=enemyChoice["prefab"]
	
	var enemyInstance=enemyPrefab.instantiate()
	add_child(enemyInstance)
	var point1=generate_random_enemy_position()#Vector2(rng.randi_range(-100,100),rng.randi_range(-100,100))
	var point2=Game.World_node.pointpositions[0]
	enemyInstance.position=point1
	enemyInstance.point1=point1
	enemyInstance.point2=point2
	enemyInstance.speed=enemyChoices[0]["speed"]
	enemiesInstances.append(enemyInstance)
	reset_timer()

func generate_random_enemy_position() -> Vector2:
	var enemy_position = Vector2.ZERO

	var edge = randi() % 4  # Randomly choose an edge (0: top, 1: right, 2: bottom, 3: left)

	match edge:
		0:  # Top edge
			enemy_position.x = rng.randi_range(boundary_rect.position.x, boundary_rect.position.x + boundary_rect.size.x)
			enemy_position.y = boundary_rect.position.y - randi() % DISTANCE_FROM_BOUNDARIES
		1:  # Right edge
			enemy_position.x = boundary_rect.position.x + boundary_rect.size.x + randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = rng.randi_range(boundary_rect.position.y, boundary_rect.position.y + boundary_rect.size.y)
		2:  # Bottom edge
			enemy_position.x = rng.randi_range(boundary_rect.position.x, boundary_rect.position.x + boundary_rect.size.x)
			enemy_position.y = boundary_rect.position.y + boundary_rect.size.y + randi() % DISTANCE_FROM_BOUNDARIES
		3:  # Left edge
			enemy_position.x = boundary_rect.position.x - randi() % DISTANCE_FROM_BOUNDARIES
			enemy_position.y = rng.randi_range(boundary_rect.position.y, boundary_rect.position.y + boundary_rect.size.y)

	return enemy_position


func reset_timer():
	var rand_timer:float=rng.randi_range(enemiesTimerMinMax.x*10,enemiesTimerMinMax.y*10)/10.0
	$EnemiesTimer.wait_time=rand_timer
	$EnemiesTimer.start()
	#print($EnemiesTimer.wait_time)
