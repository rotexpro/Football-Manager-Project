extends Node

var ratingLinkedList:Dictionary
var ratingArray:Dictionary

var startPlayers:Array
var benchPlayers:Array
var reservePlayers:Array

var formation = Formation.new()

var teamPlayers:Array

var tactics:Tactics setget setTactics

class fullSquad:
	var startPlayers:Array
	var benchPlayers:Array
	var reservePlayers:Array
	
	func _init(_staters:Array, _bench:Array, _reserve:Array):
		startPlayers = _staters
		benchPlayers = _bench
		reservePlayers = _reserve

enum position{
	starter
	bench
	reserves
}

func createTeamData(team:Array):
	startPlayers.clear()
	benchPlayers.clear()
	reservePlayers.clear()
	teamPlayers = team
	sortTopEleven()
	setstartPlayers()
	setBenchPlayers()
	setReservePlayers()
	var squad = fullSquad.new(startPlayers, benchPlayers, reservePlayers)
	return squad

func replacePlayer(position1:int, position2:int , player1:Stats, player2:Stats, starters:Array, bench:Array, reserves:Array):
	var position:int
	var idx:int
	if position1 == 1 or position2 == 1:
		position = 1
	else:
		position = 2
	print_debug("Starting replacing process")
	match position:
		1:
			var tempRole: String
			if starters.has(player1):
				tempRole = player1.role
				player2.tempRole = tempRole
				idx = starters.find(player1)
				starters[idx] = player2
				if bench.has(player2):
					idx = bench.find(player2)
					bench[idx] = player1
				elif reserves.has(player2):
					idx = reserves.find(player2)
					reserves[idx] = player1
				print("Player has been replaced")
			elif starters.has(player2):
				tempRole = player1.role
				player2.tempRole = tempRole
				idx = starters.find(player1)
				starters[idx] = player2
				if bench.has(player1):
					idx = bench.find(player1)
					bench[idx] = player2
				elif reserves.has(player1):
					idx = reserves.find(player1)
					reserves[idx] = player2
				print("Player has been replaced")
		_:
			if bench.has(player2):
				idx = bench.find(player2)
				bench[idx] = player1
				if starters.has(player1):
					idx = starters.find(player1)
					starters[idx] = player2
				elif reserves.has(player1):
					idx = reserves.find(player1)
					reserves[idx] = player2
			elif bench.has(player1):
				idx = bench.find(player1)
				bench[idx] = player2
				if starters.has(player2):
					idx = starters.find(player2)
					starters[idx] = player1
				elif reserves.has(player2):
					idx = reserves.find(player2)
					reserves[idx] = player1

func sortTopEleven():
	print("initializing rating list with LinkedList")
	ratingLinkedList = {
		"GK" : LinkedList.new(),
		"CB" : LinkedList.new(),
		"LB" : LinkedList.new(),
		"RB" : LinkedList.new(),
		"CDM" : LinkedList.new(),
		"CMF" : LinkedList.new(),
		"LMF" : LinkedList.new(),
		"RMF" : LinkedList.new(),
		"AMF" : LinkedList.new(),
		"LWF" : LinkedList.new(),
		"RWF" : LinkedList.new(),
		"SS" : LinkedList.new(),
		"CF" : LinkedList.new()
	}
	print("initializing rating array with Array")
	ratingArray = {
		"GK" : Array(),
		"CB" : Array(),
		"LB" : Array(),
		"RB" : Array(),
		"CDM" : Array(),
		"CMF" : Array(),
		"LMF" : Array(),
		"RMF" : Array(),
		"AMF" : Array(),
		"LWF" : Array(),
		"RWF" : Array(),
		"SS" : Array(),
		"CF" : Array()
	}
	
	setLinkedListRoles()
	setArrayRoles()

func setstartPlayers():
	print_debug("initializing formation data")
	var position = TeamCreator.positionSpecs
	
	print("adding players to squad i.e top eleven")
	
	#adding players
	print_debug("getting roles from player Stats class")
	var roles:Array = Stats.roleSpecs.keys()
	for val in roles:
		var role:String = val
		role = role.to_upper()
		var num = formation.getRoleNumber(role)
		print_debug("adding players in " + role + " to squad ")
		print("adding " + String(num) + " players from " + role)
		if num > 1:
			var no = 0
			while (no + 1) <= formation.getRoleNumber(role) :
				print_debug("getting player Stats")
				var player:Stats = ratingArray.get(role)[no]
				if no == 0:
					player.position = position.LEFT
					print("player position is left")
				elif no ==1:
					player.position = position.RIGHT
					print("player position is right")
				else:
					player.position = position.DEFAULT
					print("player takes a central/default position")
				startPlayers.append(player)
				no += 1
		elif formation.getRoleNumber(role) == 0:
			continue
		else:
			print_debug("getting player Stats")
			var player:Stats = ratingArray.get(role)[0]
			player.position = TeamCreator.positionSpecs.DEFAULT
			print("player takes a central/default position")
			startPlayers.append(player)
	
func setBenchPlayers():
	var bench:Array = removeElements(teamPlayers, startPlayers)
	var roles:Array = Stats.roleSpecs.keys()
	for val in roles:
		var role:String = val
		role = role.to_upper()
		for player in ratingArray.get(role):
			if bench.has(player) and formation.getRoleNumber(role) > 0:
				benchPlayers.append(player)
				break

func setReservePlayers():
	var reserves:Array = removeElements(teamPlayers, startPlayers)
	reserves = removeElements(reserves, benchPlayers)
	reservePlayers.append_array(reserves)
	
func setLinkedListRoles():
	print("setting players to LinkedList")
	for player in teamPlayers:
		print_debug("getting roles from player Stats class")
		var roles:Array = Stats.roleSpecs.keys()
		for val in roles:
			var role:String = val
			role = role.to_upper()
			if player.role == role:
				print("adding player to " + role + " linkedlist")
				ratingLinkedList[role] = setLinkedList(ratingLinkedList.get(role),player)
				print("player added")

func setLinkedList(list:LinkedList, player):
	var current = list.head
	if current == null:
		print("list is null")
		list.addFirst(player)
		print("player added")
	else:
		print_debug("adding data to existing list")
		print("running through " + String(list.getSize()) + "elements")
		while current.data.rating > player.rating and current.next != null:
			print("moving to next element")
			current = current.next
		if current.data.rating > player.rating and current.next == null:
			print_debug("adding player to end of linkedlist")
			list.addLast(player)
		elif current.data.rating < player.rating and current.prevous != null:
			print_debug(" inserting player into list")
			list.insertBefore(current,player)
		else:
			list.addFirst(player)
		print("player added")
	return list 

func setArrayRoles():
	print_debug("getting roles from player Stats class")
	var roles:Array = Stats.roleSpecs.keys()
	for val in roles:
		var role:String = val
		role = role.to_upper()
		print_debug("converting linkedlist to array")
		ratingArray[role] = ratingLinkedList.get(role).converttoArray()
		print("list converted")

# warning-ignore:unused_argument
func setTactics(val):
	tactics = Tactics.new()
	pass

func removeElements(mainArray:Array ,elementsToRemove:Array):
	for element in elementsToRemove:
		var index = mainArray.find(element)
		mainArray.erase(index)
	return mainArray



