extends Node

class_name Stats

enum roleSpecs{
	GK,
	CB,
	LB,
	RB,
	CDM,
	CMF,
	LMF,
	RMF,
	AMF,
	LWF,
	RWF,
	SS,
	CF
}


export(int) var speed = 100
export(String) var playerName
export(String) var country
export(int) var age
export(roleSpecs) var role
export(roleSpecs) var tempRole 
export(int) var attack
export(int) var dribble
export(int) var pas
export(int) var cross
export(int) var curve
export(int) var defence
export(int) var shot
export(int) var physique
export(int) var form
export(int) var stamina
export(int) var rating:int

var position

#team instruction familiarity
var passBias
var playAreaBias
var formationBias 
var progressionBias
var pressureBias
var attackBias = 50
var defenseBias = 50

func _init(_name:String, _country:String, _age:int, _role:String, _shot:int, _pass:int, _cross:int, _curve:int, _form:int, _ATK:int, _STR:int, _STA:int, _DEF:int, _DRI:int, _SPD:int):
	playerName = _name
	country = _country
	age = _age
	role = _role
	tempRole = role
	shot = _shot
	pas = _pass
	cross = _cross
	curve = _curve
	form = _form
	attack = _ATK
	physique = _STR
	stamina = _STA
	defence = _DEF
	dribble = _DRI
	speed = _SPD
	overallRating()

func playertactics(_pressureBias = 1, _defenseBias = 1, _passBias = 5, _playAreaBias = 5, _formationBias = 5, _progressionBias = 5):
	passBias = _passBias
	playAreaBias = _playAreaBias
	formationBias = _formationBias
	progressionBias = _progressionBias
	pressureBias = _pressureBias
	defenseBias = _defenseBias

func overallRating():
	print_debug("setting player:" + playerName + "rating")
	if (role == "GK" || role == "CB" || role == "CDM"):
		rating = ((defence * 0.3)+(pas*0.2)+(defenseBias*0.25)+(physique*0.15)+(stamina*0.1))
	if (role == "LB" || role == "RB"):
		rating = ((defence * 0.25)+(pas*0.1)+(defenseBias*0.15)+(physique*0.1)+(stamina*0.1)+(attack * 0.15) + (attackBias * 0.1)+ (dribble * 0.05))
	if (role == "CMF" || role == "AMF"):
		rating = ((defence * 0.1)+(pas*0.2)+(defenseBias*0.1)+(physique*0.1)+(stamina*0.15)+(attack * 0.1) + (attackBias * 0.1)+ (dribble * 0.15))
	if (role == "RMF" || role == "LMF"):
		rating = ((defence * 0.1)+(pas*0.1)+(defenseBias*0.1)+(physique*0.1)+(stamina*0.15)+(attack * 0.15) + (attackBias * 0.1)+ (dribble * 0.05) + (cross * 0.1) + (curve * 0.05))
	if (role == "RWF" || role == "LWF"):
		rating = ((defence * 0.05)+(pas*0.1)+(defenseBias*0.05)+(physique*0.1)+(stamina*0.15)+(attack * 0.2) + (attackBias * 0.1)+ (dribble * 0.1) + (cross * 0.1) + (curve * 0.05))
	if (role == "SS" || role == "CF"):
		rating = ((defence * 0.05)+(pas*0.1)+(defenseBias*0.05)+(physique*0.15)+(stamina*0.15)+(attack * 0.2) + (attackBias * 0.1)+ (dribble * 0.1) + (cross * 0.05) + (curve * 0.05))
	print("player rating complete")





























