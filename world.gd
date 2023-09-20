extends Node2D

@onready var line2d_scene = preload("res://line_2d.tscn")
@onready var fillpolygon_scene = preload("res://fill_polygon.tscn")

var pointpositions=[]
var lineconnections={}
var checkedlines=[]
var lines_pairs=[["12","01","02"],["23","02","03"],["34","03","04"],["41","04","01"]]
var fill_obj_list=[]

func _ready():
	pointpositions.append($Point0.position)
	pointpositions.append($Point1.position)
	pointpositions.append($Point2.position)
	pointpositions.append($Point3.position)
	pointpositions.append($Point4.position)
	print(pointpositions)
	
	var line2d_instance_01 = line2d_scene.instantiate()
	add_child(line2d_instance_01)
	lineconnections["01"]=(line2d_instance_01)
	line2d_instance_01.add_point(pointpositions[0],0)
	line2d_instance_01.add_point(pointpositions[1],0)
	
	var line2d_instance_02 = line2d_scene.instantiate()
	add_child(line2d_instance_02)
	lineconnections["02"]=(line2d_instance_02)
	line2d_instance_02.add_point(pointpositions[0],0)
	line2d_instance_02.add_point(pointpositions[2],0)
	
	var line2d_instance_03 = line2d_scene.instantiate()
	add_child(line2d_instance_03)
	lineconnections["03"]=(line2d_instance_03)
	line2d_instance_03.add_point(pointpositions[0],0)
	line2d_instance_03.add_point(pointpositions[3],0)
	
	var line2d_instance_04 = line2d_scene.instantiate()
	add_child(line2d_instance_04)
	lineconnections["04"]=(line2d_instance_04)
	line2d_instance_04.add_point(pointpositions[0],0)
	line2d_instance_04.add_point(pointpositions[4],0)
	
	
	var line2d_instance_12 = line2d_scene.instantiate()
	add_child(line2d_instance_12)
	lineconnections["12"]=(line2d_instance_12)
	line2d_instance_12.add_point(pointpositions[1],0)
	line2d_instance_12.add_point(pointpositions[2],0)
	
	var line2d_instance_23 = line2d_scene.instantiate()
	add_child(line2d_instance_23)
	lineconnections["23"]=(line2d_instance_23)
	line2d_instance_23.add_point(pointpositions[2],0)
	line2d_instance_23.add_point(pointpositions[3],0)
	
	var line2d_instance_34 = line2d_scene.instantiate()
	add_child(line2d_instance_34)
	lineconnections["34"]=(line2d_instance_34)
	line2d_instance_34.add_point(pointpositions[3],0)
	line2d_instance_34.add_point(pointpositions[4],0)
	
	var line2d_instance_41 = line2d_scene.instantiate()
	add_child(line2d_instance_41)
	lineconnections["41"]=(line2d_instance_41)
	line2d_instance_41.add_point(pointpositions[4],0)
	line2d_instance_41.add_point(pointpositions[1],0)
	
	print(lineconnections)
	
	var linefill_tr = fillpolygon_scene.instantiate()
	var offset=linefill_tr.get_child(0).offset
	add_child(linefill_tr)
	linefill_tr.get_child(0).polygon=[pointpositions[0]-offset,pointpositions[1]-offset,pointpositions[2]-offset]
	fill_obj_list.append(linefill_tr)
	linefill_tr.scale=Vector2(0,0)
#	var tweenScale=get_tree().create_tween()
#	tweenScale.tween_property(linefill_tr,"scale",Vector2(0,0),4)
	
	var linefill_br = fillpolygon_scene.instantiate()
	add_child(linefill_br)
	linefill_br.get_child(0).polygon=[pointpositions[0]-offset,pointpositions[2]-offset,pointpositions[3]-offset]
	fill_obj_list.append(linefill_br)
	linefill_br.scale=Vector2(0,0)
	
	var linefill_bl = fillpolygon_scene.instantiate()
	add_child(linefill_bl)
	linefill_bl.get_child(0).polygon=[pointpositions[0]-offset,pointpositions[3]-offset,pointpositions[4]-offset]
	fill_obj_list.append(linefill_bl)
	linefill_bl.scale=Vector2(0,0)
	
	var linefill_tl = fillpolygon_scene.instantiate()
	add_child(linefill_tl)
	linefill_tl.get_child(0).polygon=[pointpositions[0]-offset,pointpositions[4]-offset,pointpositions[1]-offset]
	fill_obj_list.append(linefill_tl)
	linefill_tl.scale=Vector2(0,0)

func _process(delta):
	if(len(checkedlines)>=8):#pointpositions.size()*2):
		finish_diamond()
		
func finish_diamond():
	for lineid in lineconnections:
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(0,1,1),0.05)
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(1,1,1),0.1)
	checkedlines.clear()
	for linefill in fill_obj_list:
		var tweenScale=get_tree().create_tween()
		tweenScale.tween_property(linefill,"scale",Vector2(0,0),0.05)
		#print(linefill.scale)
	Game.score+=5*Game.scoreMultiplier

func check_line(lineid):
	if(lineid not in checkedlines):
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(0.0,0.5,0.5),0.05)
		checkedlines.append(lineid)
	
	print()
	for i in range(lines_pairs.size()):
		var pair=lines_pairs[i]
		if pairoflines_exists(pair):
			#fill_obj_list[i].scale=Vector2(1,1)
			var tweenScale=get_tree().create_tween()
			tweenScale.tween_property(fill_obj_list[i],"scale",Vector2(1,1),0.05)
			#print("Pair", pair, "found in checkedlines")

func pairoflines_exists(pair)->bool:
	for item in checkedlines:
		var found = true
		for element in pair:
			if element not in checkedlines:
				found = false
				break
		if found:
			return true
	return false
#func pairoflines_exists(pair, list)->bool:
#	for item in list:
#		var sorted_pair = pair.duplicate().sort()
#		var sorted_item = item.duplicate().sort()
#		if sorted_pair == sorted_item:
#			return true
#	return false




#class LineConnection:
