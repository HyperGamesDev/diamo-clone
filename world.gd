extends Node2D

@onready var line_scene = preload("res://line.tscn")
@onready var fillpolygon_scene = preload("res://fill_polygon.tscn")

var pointpositions=[]
var lineconnections={}
var line_fill_obj_list=[]
var checkedlines=[]
var checkedlines_new=[]
var lines_pairs=[["12","01","02"],["23","02","03"],["34","03","04"],["41","04","01"]]

const linefill_decayTimerMax=4
const linefill_decaySpeed=0.4

func _ready():
	pointpositions.append($Point0.position)
	pointpositions.append($Point1.position)
	pointpositions.append($Point2.position)
	pointpositions.append($Point3.position)
	pointpositions.append($Point4.position)
	
	var line_instance_01 = line_scene.instantiate()
	line_instance_01.name="line_"+"01"
	add_child(line_instance_01)
	lineconnections["01"]=(line_instance_01)
	line_instance_01.add_point(pointpositions[0],0)
	line_instance_01.add_point(pointpositions[1],0)
	
	var line_instance_02 = line_scene.instantiate()
	add_child(line_instance_02)
	lineconnections["02"]=(line_instance_02)
	line_instance_02.add_point(pointpositions[0],0)
	line_instance_02.add_point(pointpositions[2],0)
	
	var line_instance_03 = line_scene.instantiate()
	add_child(line_instance_03)
	lineconnections["03"]=(line_instance_03)
	line_instance_03.add_point(pointpositions[0],0)
	line_instance_03.add_point(pointpositions[3],0)
	
	var line_instance_04 = line_scene.instantiate()
	add_child(line_instance_04)
	lineconnections["04"]=(line_instance_04)
	line_instance_04.add_point(pointpositions[0],0)
	line_instance_04.add_point(pointpositions[4],0)
	
	
	var line_instance_12 = line_scene.instantiate()
	add_child(line_instance_12)
	lineconnections["12"]=(line_instance_12)
	line_instance_12.add_point(pointpositions[1],0)
	line_instance_12.add_point(pointpositions[2],0)
	
	var line_instance_23 = line_scene.instantiate()
	add_child(line_instance_23)
	lineconnections["23"]=(line_instance_23)
	line_instance_23.add_point(pointpositions[2],0)
	line_instance_23.add_point(pointpositions[3],0)
	
	var line_instance_34 = line_scene.instantiate()
	add_child(line_instance_34)
	lineconnections["34"]=(line_instance_34)
	line_instance_34.add_point(pointpositions[3],0)
	line_instance_34.add_point(pointpositions[4],0)
	
	var line_instance_41 = line_scene.instantiate()
	add_child(line_instance_41)
	lineconnections["41"]=(line_instance_41)
	line_instance_41.add_point(pointpositions[4],0)
	line_instance_41.add_point(pointpositions[1],0)
	
	#print(lineconnections)
	
	
	var fillpolygon_tr = fillpolygon_scene.instantiate()
	var offset=fillpolygon_tr.get_child(0).offset
	add_child(fillpolygon_tr)
	fillpolygon_tr.setup(0,1,2)
	line_fill_obj_list.append(fillpolygon_tr)
	
	var fillpolygon_br = fillpolygon_scene.instantiate()
	add_child(fillpolygon_br)
	fillpolygon_br.setup(0,2,3)
	line_fill_obj_list.append(fillpolygon_br)
	
	var fillpolygon_bl = fillpolygon_scene.instantiate()
	add_child(fillpolygon_bl)
	fillpolygon_bl.setup(0,3,4)
	line_fill_obj_list.append(fillpolygon_bl)
	
	var fillpolygon_tl = fillpolygon_scene.instantiate()
	add_child(fillpolygon_tl)
	fillpolygon_tl.setup(0,4,1)
	line_fill_obj_list.append(fillpolygon_tl)


func _process(delta):
	if(len(checkedlines)>=8):#pointpositions.size()*2):
		finish_diamond()
		
		
		
func finish_diamond():
	for lineid in lineconnections:
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(0,1,1),0.05)
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(1,1,1),0.1)
	checkedlines.clear()
	for linefill in line_fill_obj_list:
		linefill.reset_checked()
		var tweenScale=get_tree().create_tween()
		tweenScale.tween_property(linefill,"scale",Vector2(1,1),0.025)
		tweenScale.tween_property(linefill,"scale",Vector2(0,0),0.05)
	Game.add_score(Game.scoreForDiamond)

func check_line(lineid):
#	checkedlines=[]
#	for item in line_fill_obj_list:
#		checkedlines.append(item.pairing)
	
	if(lineid in checkedlines and lineid not in checkedlines_new):
		checkedlines_new.append(lineid)
	if(lineid not in checkedlines):
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(0.0,0.5,0.5),0.05)
		checkedlines.append(lineid)
	
	print()
	print(checkedlines)
	for i in range(lines_pairs.size()):
		var pair=lines_pairs[i]
		if pairoflines_exists(pair,checkedlines):
			if(line_fill_obj_list[i].checked==false):
				line_fill_obj_list[i].set_checked()
				var tweenScale=get_tree().create_tween()
				print(line_fill_obj_list[i].scale)
				tweenScale.tween_property(line_fill_obj_list[i],"scale",Vector2(1,1),0.05)
				print(line_fill_obj_list[i].scale)
#			else:##We need to make it refresh the timer someplace else
#				line_fill_obj_list[i].decayTimer=linefill_decayTimerMax
		if pairoflines_exists(pair,checkedlines_new):
			line_fill_obj_list[i].decayTimer=linefill_decayTimerMax
			for element in pair:
				checkedlines_new.erase(element)

func uncheck_line_fill(lineid,fillobj):
	if(not checkifline_isonactivefill(lineid,fillobj)):
		uncheck_line(lineid)
		
func uncheck_line(lineid):
	if(lineid in checkedlines):
		var tweenColor=get_tree().create_tween()
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(0.6,0.6,0.6),0.05)
		tweenColor.tween_property(lineconnections[lineid],"default_color",Color(1,1,1),0.05)
		checkedlines.erase(lineid)
		checkedlines_new.erase(lineid)
		print(str(lineid)+" removed")

func pairoflines_exists(pair,list=checkedlines)->bool:
	for item in line_fill_obj_list:
		var found = true
		for element in pair:
			if element not in list:
				found = false
				break
		if found:
			return true
	return false
	
func checkifline_isonactivefill(lineid,fillobj):
	var other_fills_list=line_fill_obj_list.duplicate()
	other_fills_list.erase(fillobj)
	for item in other_fills_list:
		if lineid in item.pairing and item.checked:
			return true
