extends Node

class_name Formation

#var formation = "F433"
var formation

var gk:int
var rb:int
var lb:int
var cb:int
var cdm:int
var cmf:int
var lmf:int
var rmf:int
var amf:int
var lwf:int
var rwf:int
var ss:int
var cf:int

var roles:Dictionary

enum formations {
	F433
	F442
	F4231
	F442
	F334
	F343
	F4321
	F4312
	F532
	F541
}

func _init():
	setRoleNumber()

func setRoleNumber():
	print("Getting formation role number ")
	match formation :
		formations.F442:
			pass
		_:
			gk = 1
			rb = 1
			lb = 1
			cb = 2
			cdm = 1
			cmf = 2
			lmf = 0
			rmf = 0
			amf = 0
			lwf = 1
			rwf = 1
			ss = 0
			cf = 1
	var total = gk + cb + lb + rb + cdm + cmf + lmf + rmf + amf + lwf + rwf + ss + cf
	if total < 11 or total > 11:
		printerr("Number of Players doesn't correspond")
	print("Roles have been set")
	
	roles = {
		"GK": gk,
		"CB": cb,
		"RB": rb,
		"LB": lb,
		"CDM": cdm,
		"CMF": cmf,
		"LMF": lmf,
		"RMF": rmf,
		"AMF": amf,
		"LWF": lwf,
		"RWF": rwf,
		"SS": ss,
		"CF": cf
	}

func getRoleNumber(val):
	return roles.get(val)
