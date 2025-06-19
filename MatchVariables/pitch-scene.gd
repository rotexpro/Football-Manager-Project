extends Node2D

var homePosDic:Dictionary = {
	"GK" : Vector2(),
	"CB" : Vector2(),
	"LB" : Vector2(),
	"RB" : Vector2(),
	"CDM" : Vector2(),
	"CMF" : Vector2(),
	"LMF" : Vector2(),
	"RMF" : Vector2(),
	"AMF" : Vector2(),
	"LWF" : Vector2(),
	"RWF" : Vector2(),
	"SS" : Vector2(),
	"CF" : Vector2(),
	"KICKOFF" : Vector2()
}
var awayPosDic:Dictionary = {
	"GK" : Vector2(),
	"CB" : Vector2(),
	"LB" : Vector2(),
	"RB" : Vector2(),
	"CDM" : Vector2(),
	"CMF" : Vector2(),
	"LMF" : Vector2(),
	"RMF" : Vector2(),
	"AMF" : Vector2(),
	"LWF" : Vector2(),
	"RWF" : Vector2(),
	"SS" : Vector2(),
	"CF" : Vector2(),
	"KICKOFF" : Vector2()
}

var gridPos:Dictionary = {
	"START" : Vector2(),
	"END" : Vector2(),
	"GOAL_KEEPER_BOX_TOP": Vector2(),
	"GOAL_KEEPER_BOX_BOTTOM": Vector2()
}

onready var centerPos = $"pitch-positions/centre-line".global_transform.origin
onready var awayGoal = $Outfieldpositions/Awaygoalpost

func _ready():
	homepositions()
	awaypositions()
	grids()

#Get Home Player Positions and save to dictionary
func homepositions():
	homePosDic["GK"] = $"home-match-pos/GK".global_transform.origin
	homePosDic["CB"] = $"home-match-pos/CB".global_transform.origin
	homePosDic["LB"] = $"home-match-pos/LB".global_transform.origin
	homePosDic["RB"] = $"home-match-pos/RB".global_transform.origin
	homePosDic["CMF"] = $"home-match-pos/CMF".global_transform.origin
	homePosDic["CDM"] = $"home-match-pos/CDM".global_transform.origin
	homePosDic["LMF"] = $"home-match-pos/LMF".global_transform.origin
	homePosDic["RMF"] = $"home-match-pos/RMF".global_transform.origin
	homePosDic["AMF"] = $"home-match-pos/AMF".global_transform.origin
	homePosDic["CF"] = $"home-match-pos/CF".global_transform.origin
	homePosDic["LWF"] = $"home-match-pos/LWF".global_transform.origin
	homePosDic["RWF"] = $"home-match-pos/RWF".global_transform.origin
	homePosDic["KICKOFF"] = $Outfieldpositions/Homekickoffpos.global_transform.origin
	return homePosDic

#Get Away Player Positions and save to dictionary
func awaypositions():
	awayPosDic["GK"] = $"away-match-pos/GK".global_transform.origin
	awayPosDic["CB"] = $"away-match-pos/CB".global_transform.origin
	awayPosDic["LB"] = $"away-match-pos/LB".global_transform.origin
	awayPosDic["RB"] = $"away-match-pos/RB".global_transform.origin
	awayPosDic["CMF"] = $"away-match-pos/CMF".global_transform.origin
	awayPosDic["CDM"] = $"away-match-pos/CDM".global_transform.origin
	awayPosDic["LMF"] = $"away-match-pos/LMF".global_transform.origin
	awayPosDic["RMF"] = $"away-match-pos/RMF".global_transform.origin
	awayPosDic["AMF"] = $"away-match-pos/AMF".global_transform.origin
	awayPosDic["CF"] = $"away-match-pos/CF".global_transform.origin
	awayPosDic["LWF"] = $"away-match-pos/LWF".global_transform.origin
	awayPosDic["RWF"] = $"away-match-pos/RWF".global_transform.origin
	awayPosDic["KICKOFF"] = $Outfieldpositions/Awaykickoffpos.global_transform.origin
	return awayPosDic


func grids():
	gridPos["START"] = $Outfieldpositions/gridStartPos.global_transform.origin
	gridPos["END"] = $Outfieldpositions/gridEndPos.global_transform.origin
	gridPos["GOAL_KEEPER_BOX_TOP"] = $"pitch-positions/goal-keeper-line-top".global_transform.origin
	gridPos["GOAL_KEEPER_BOX_BOTTOM"] = $"pitch-positions/goal-keeper-line-bottom".global_transform.origin
	return gridPos













