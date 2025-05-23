extends Node

class_name Tactics

enum attackStyle{ #style of attacking play
	counter
	possession
}

enum positioning{ # do players fill the spaces
	maintain
	flexible
}

enum markingStyle{
	manToMan
	conservative
}

export(attackStyle) var attack
export(positioning) var flexibility
export(markingStyle) var marking

var attackBias: float = 0.4

var supportRange:float = 0.5  

var supportNo:int = 3 #number of players that support

var path = "res://general scripts/User/save_tactics.json"

var passFile="fwegfuywe7r632r7312ghdjfvjhfesedwfcdewqyhfewjf"


func prepareTactics():
	pass









#var details:Dictionary = {
#	"username" : userName,
#	"clubname" : clubName
#}
#
#func _ready():
#	var file = File.new()
#	print_debug(" Getting User Tactics")
#
#	if file.file_exists(path):
#		print("File Path exists")
#		loadGame()
#	else:
#		saveUser()
#
#
#func saveUser():
#	var file = File.new()
#	print("Saving User Details")
#	file.open_encrypted_with_pass (path, File.WRITE,passFile)
#	file.store_string(to_json(details))
#	file.close()
#
#
#func loadGame():
#	var file = File.new()
#
#	file.open_encrypted_with_pass (path, File.READ,passFile)
#	var data = parse_json(file.get_as_text())
#	file.close()
#
#	print_debug("Getting User Details from file")
#	if typeof(data) == TYPE_DICTIONARY:
#		details = data
#	else:
#		printerr("Corrupted data!")








