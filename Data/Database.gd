extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://Data/DataStore/fm_db"

var playerinfoarray:Array


var playerstats:Array
var clubTeam:Array

var oppTeam:Array


func _ready():
	if OS.get_name() in ["Windows"] or OS.get_name() in ["Android"]:
		copyPath()
		db_name = "user://fm_db"
	db = sqlite.new()
	db.path = db_name
	db.open_db()
	getClubTeam()
	db.close_db()

func copyPath():
	print_debug("copying data to user dir")
	var dir = Directory.new()
	dir.copy("res://DataStore/fm_db.db", "user://GameData/fm_db.db")
	print("data copied")

func getAllPlayers():
	print_debug("getting players from database")
	db = sqlite.new()
	db.path = db_name
	db.open_db()
	db.query("SELECT Players.name, Players.age, Players.attack, Players.speed,Players.defence, Players.cross, Players.pass, Players.curve, Players.physique, Players.form, Players.stamina, Players.dribble, Players.shot, Role.name as role, Country.name as country FROM Players LEFT JOIN Role on Players.roleid = role.id JOIN Country on Players.countryid = Country.id ")
	print(" Getting Query Results ")
	print_debug(db.error_message)
	for stat in db.query_result:
		print_debug("saving data to player pojo")
		playerstats.append(Stats.new(stat.name, stat.country, stat.age, stat.role, stat.shot, stat.pass, stat.cross, stat.curve, stat.form, stat.attack, stat.physique, stat.stamina, stat.defence, stat.dribble, stat.speed))
	print("players gotten")

func getClubTeam():
	print_debug("getting players for " + User.clubName + " from database")
	db.path = db_name
	var userName = User.userName
	db.query("SELECT Players.name, Players.age, Players.attack, Players.speed,Players.defence, Players.cross, Players.pass, Players.curve, Players.physique, Players.form, Players.stamina, Players.dribble, Players.shot, Role.name as role, Country.name as country, user.club as club, user.name as manager FROM Players LEFT JOIN Role on Players.roleid = role.id JOIN Country on Players.countryid = Country.id JOIN user on Players.club = user.id WHERE manager = '" + userName + "'")
	print(" Getting Query Results for club Team ")
	print_debug(db.error_message)
	for stat in db.query_result:
		print_debug("saving data to player pojo")
		clubTeam.append(Stats.new(stat.name, stat.country, stat.age, stat.role, stat.shot, stat.pass, stat.cross, stat.curve, stat.form, stat.attack, stat.physique, stat.stamina, stat.defence, stat.dribble, stat.speed))
	print("players gotten")

func getTeam(UserName):
	print_debug("getting players for " + UserName + " from database")
	db = sqlite.new()
	db.path = db_name
	db.open_db()
	var managerName
	db.query("SELECT Players.name, Players.age, Players.attack, Players.speed,Players.defence, Players.cross, Players.pass, Players.curve, Players.physique, Players.form, Players.stamina, Players.dribble, Players.shot, Role.name as role, Country.name as country, user.club as club, user.name as manager FROM Players LEFT JOIN Role on Players.roleid = role.id JOIN Country on Players.countryid = Country.id JOIN user on Players.club = user.id WHERE manager = '" + UserName + "'")
	print(" Getting Query Results for club Team ")
	print_debug(db.error_message)
	db.close_db()
	for stat in db.query_result:
		print_debug("saving data to player pojo")
		oppTeam.append(Stats.new(stat.name, stat.country, stat.age, stat.role, stat.shot, stat.pass, stat.cross, stat.curve, stat.form, stat.attack, stat.physique, stat.stamina, stat.defence, stat.dribble, stat.speed))
	print("players gotten")
	return oppTeam














