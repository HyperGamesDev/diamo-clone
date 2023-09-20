extends Node2D

var pairing=["12","01","02"]
var checked:bool=false
@onready var decayTimer:float=0

func _ready():
	scale=Vector2(0,0)
	
func setup(point0,point1,point2):
	var line0=str(point1)+str(point2)
	var line1=str(point0)+str(point1)
	var line2=str(point0)+str(point2)
	pairing=[line0,line1,line2]
	
	var offset=get_child(0).offset
	get_child(0).polygon=[Game.World_node.pointpositions[point0]-offset,Game.World_node.pointpositions[point1]-offset,Game.World_node.pointpositions[point2]-offset]
	
func _process(delta):
	if(decayTimer>0):
		decayTimer-=Game.World_node.linefill_decaySpeed*delta
	var size=decayTimer/Game.World_node.linefill_decayTimerMax
	scale=Vector2(size,size)
	if(decayTimer<=0 and checked):
		for lineid in pairing:
			Game.World_node.uncheck_line_fill(lineid,self)
		checked=false

func set_checked():
	checked=true
	decayTimer=Game.World_node.linefill_decayTimerMax
	
func reset_checked():
	checked=false
	decayTimer=0
