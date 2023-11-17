extends Node2D

@onready var line_scene = preload("res://World/line.tscn")
@onready var fillpolygon_scene = preload("res://World/fill_polygon.tscn")

var pointpositions=[]
var lineconnections={}
var line_fill_obj_list=[]
var checkedlines=[]
var checkedlines_new=[]
var lines_pairs=[["12","01","02"],["23","02","03"],["34","03","04"],["41","04","01"]]

const linefill_decayTimerMax=10

const line_enableTimerMax=8

const lineColor=Color(0.4,0.4,0.4)
const lineColorChecked=Color("1b9c95")

func _ready():
	pointpositions.append($Points/Point0.position)
	pointpositions.append($Points/Point1.position)
	pointpositions.append($Points/Point2.position)
	pointpositions.append($Points/Point3.position)
	pointpositions.append($Points/Point4.position)
	
	var line_instance_01 = line_scene.instantiate()
	$Lines.add_child(line_instance_01)
	lineconnections["01"]=(line_instance_01)
	line_instance_01.setup("01",pointpositions[0],pointpositions[1],false)
	line_instance_01.default_color=lineColor
	
	var line_instance_02 = line_scene.instantiate()
	$Lines.add_child(line_instance_02)
	lineconnections["02"]=(line_instance_02)
	line_instance_02.setup("02",pointpositions[0],pointpositions[2],false)
	line_instance_02.default_color=lineColor
	
	var line_instance_03 = line_scene.instantiate()
	$Lines.add_child(line_instance_03)
	lineconnections["03"]=(line_instance_03)
	line_instance_03.setup("03",pointpositions[0],pointpositions[3],false)
	line_instance_03.default_color=lineColor
	
	var line_instance_04 = line_scene.instantiate()
	$Lines.add_child(line_instance_04)
	lineconnections["04"]=(line_instance_04)
	line_instance_04.setup("04",pointpositions[0],pointpositions[4],false)
	line_instance_04.default_color=lineColor
	
	
	var line_instance_12 = line_scene.instantiate()
	$Lines.add_child(line_instance_12)
	lineconnections["12"]=(line_instance_12)
	line_instance_12.setup("12",pointpositions[1],pointpositions[2])
	line_instance_12.default_color=lineColor
	
	var line_instance_23 = line_scene.instantiate()
	$Lines.add_child(line_instance_23)
	lineconnections["23"]=(line_instance_23)
	line_instance_23.setup("23",pointpositions[2],pointpositions[3])
	line_instance_23.default_color=lineColor
	
	var line_instance_34 = line_scene.instantiate()
	$Lines.add_child(line_instance_34)
	lineconnections["34"]=(line_instance_34)
	line_instance_34.setup("34",pointpositions[3],pointpositions[4])
	line_instance_34.default_color=lineColor
	
	var line_instance_41 = line_scene.instantiate()
	$Lines.add_child(line_instance_41)
	lineconnections["41"]=(line_instance_41)
	line_instance_41.setup("41",pointpositions[4],pointpositions[1])
	line_instance_41.default_color=lineColor
	
	#print(lineconnections)
	
	
	var fillpolygon_tr = fillpolygon_scene.instantiate()
	fillpolygon_tr.name="FillPolygon_"+"tr"
	var offset=fillpolygon_tr.get_child(0).offset
	$FillPolygons.add_child(fillpolygon_tr)
	fillpolygon_tr.setup(0,1,2)
	line_fill_obj_list.append(fillpolygon_tr)
	
	var fillpolygon_br = fillpolygon_scene.instantiate()
	fillpolygon_br.name="FillPolygon_"+"br"
	$FillPolygons.add_child(fillpolygon_br)
	fillpolygon_br.setup(0,2,3)
	line_fill_obj_list.append(fillpolygon_br)
	
	var fillpolygon_bl = fillpolygon_scene.instantiate()
	fillpolygon_bl.name="FillPolygon_"+"bl"
	$FillPolygons.add_child(fillpolygon_bl)
	fillpolygon_bl.setup(0,3,4)
	line_fill_obj_list.append(fillpolygon_bl)
	
	var fillpolygon_tl = fillpolygon_scene.instantiate()
	fillpolygon_tl.name="FillPolygon_"+"tl"
	$FillPolygons.add_child(fillpolygon_tl)
	fillpolygon_tl.setup(0,4,1)
	line_fill_obj_list.append(fillpolygon_tl)


func _process(delta):
	if(len(checkedlines)>=8):#pointpositions.size()*2):
		finish_diamond()
		
		
		
func finish_diamond():
	for lineid in lineconnections:
		lineconnections[lineid].finish_diamond_reset()
	checkedlines.clear()
	for linefill in line_fill_obj_list:
		linefill.finish_diamond_reset()
	Game.add_score(Game.scoreForDiamond)
	Game.score_popup(Game.scoreForDiamond)

func check_line(lineid):
	if(lineid in checkedlines and lineid not in checkedlines_new):
		checkedlines_new.append(lineid)
	if(lineid not in checkedlines):
		lineconnections[lineid].set_checked()
		checkedlines.append(lineid)
	
	for i in range(lines_pairs.size()):
		var pair=lines_pairs[i]
		if pairoflines_exists(pair,checkedlines):
			if(line_fill_obj_list[i].filled==false):
				line_fill_obj_list[i].set_filled()
		if pairoflines_exists(pair,checkedlines_new):
			line_fill_obj_list[i].set_filled()##Reset timer
			for element in pair:
				checkedlines_new.erase(element)

		
func uncheck_line(lineid):
	if(getlinefill_filled(lineid)!=null):
		print()
		print(lineid)
		getlinefill_filled(lineid).reset_filled()
				
	if(lineid in checkedlines):
		lineconnections[lineid].reset_checked()
		checkedlines.erase(lineid)
		checkedlines_new.erase(lineid)

func uncheck_line_fill(lineid,fillobj):
	if(not checkifline_isonactivefill(lineid,fillobj)):
		uncheck_line(lineid)

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
		if lineid in item.pairing and item.filled:
			return true
			

func checkifline_isonactivefill_any(lineid):
	for item in line_fill_obj_list:
		if lineid in item.pairing and item.filled:
			return true

func getlinefill_filled(lineid):
	for item in line_fill_obj_list:
		print(item.pairing)
		print(item.filled)
		if lineid in item.pairing and item.filled:
			print("Matched pairing: "+str(item.pairing))
			return item
	
	
func get_lineid(id1,id2)->String:
	var lineid:String=str(id1)+str(id2)
	if(!lineconnections.has(lineid)):
		lineid=str(id2)+str(id1) ##Reverse the string
		if(lineconnections.has(lineid)):
			return lineid
		else:
			print("Lineid not found with any combination of: "+lineid)
			return ""
	else:
		return lineid
		
func get_point_to_the_left(point)->int:
	if(point<4):
		return point+1
	else:
		return 1
		
func get_point_to_the_right(point)->int:
	if(point>1):
		return point-1
	else:
		return 4

func _on_tree_entered():
	Game.reload_references()
