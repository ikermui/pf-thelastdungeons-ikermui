extends Node

signal dataChange
signal gameOver
var email = null

func _ready():
	loadGame()
	saveGame()

var sword_level: int = 1:
	get:
		return sword_level
	set(value):
		sword_level = clamp(value, 1, 3)
		if(sword_level >= 3):
			sword_level = 3
		dataChange.emit()

var actualObject: Texture2D:
	get:
		return actualObject
	set(value):
		actualObject = value
		dataChange.emit()

var idObject: int:
	get:
		return idObject
	set(value):
		idObject = value
		dataChange.emit()

var coins: int = 0:
	get:
		return coins
	set(value):
		coins = clamp(value, 0, max_coins)
		if(coins >= max_coins):
			coins = max_coins
		dataChange.emit()

var max_coins: int = 999:
	get:
		return max_coins
	set(value):
		max_coins = max(value, max_coins)
		dataChange.emit()            

var magic: int = 0:
	get:
		return magic
	set(value):
		magic = clamp(value, 1, max_magic)
		if(magic >= max_magic):
			magic = max_magic
		dataChange.emit()

var max_magic: int = 100:
	get:
		return max_magic
	set(value):
		max_magic = max(value, max_magic)
		dataChange.emit()    

var bombs: int = 0:
	get:
		return bombs
	set(value):
		bombs = clamp(value, 0, max_bombs)
		if(bombs >= max_bombs):
			bombs = max_bombs
		dataChange.emit()

var max_bombs: int = 20:
	get:
		return max_bombs
	set(value):
		max_bombs = max(value, max_bombs)
		dataChange.emit()    
		
var arrows: int = 0:
	get:
		return arrows
	set(value):
		print(str(arrows) + " " + str(value))
		arrows = clamp(value, 0, max_arrows)
		if(arrows >= max_arrows):
			arrows = max_arrows
		dataChange.emit()

var max_arrows: int = 40:
	get:
		return max_arrows
	set(value):
		max_arrows = max(value, max_arrows)
		dataChange.emit()  

var health: int = 2:
	get:
		return health
	set(value):
		health = clamp(value, 0, max_health)
		if(health >= max_health):
			health = max_health

		if(health <= 0):
			gameOver.emit()

		dataChange.emit()

var max_health: int = 9:
	get:
		return max_health
	set(value):
		max_health = max(value, max_health)
		dataChange.emit()                                                      

var points: int = 0:
	get:
		return points
	set(value):
		points = value
		dataChange.emit()

var mapLocation: String = "house":
	get:
		return mapLocation
	set(value):
		mapLocation = value
		dataChange.emit()

var lakeRune: bool = false:
	get:
		return lakeRune
	set(value):
		lakeRune = value
		dataChange.emit()

var desertRune: bool = false:
	get:
		return desertRune
	set(value):
		desertRune = value
		dataChange.emit()

var darkRune: bool = false:
	get:
		return darkRune
	set(value):
		darkRune = value
		dataChange.emit()

var firstDialogueShow: bool = true:
	get:
		return firstDialogueShow
	set(value):
		firstDialogueShow = value
		dataChange.emit()

func saveGame():

	if(false):
		print("No sera asi")
		# var http = HTTPRequest.new()
		# add_child(http)
		# http.request_completed.connect(_on_save_completed)
		# var save_data = obtainData()
		# var url = "http://localhost:3000/save/saveGame/" + email
		# var headers = ["Content-Type: application/json"]
		# var json = JSON.new()
		# var json_body = json.stringify(save_data)

		# var error = http.request(url, headers, HTTPClient.METHOD_PATCH, json_body)
		# if error != OK:
		# 	print("Error al enviar la solicitud PATCH:", error)

	else: 	
		var file = FileAccess.open("user://dataGame.json", FileAccess.WRITE)
		var data = {}
		
		data["sword_level"] = sword_level
		data["max_bombs"] = max_bombs
		data["max_arrows"] = max_arrows
		data["max_health"] = max_health
		data["coins"] = coins
		data["bombs"] = bombs
		data["arrows"] = arrows
		data["health"] = health
		data["magic"] = magic
		data["current_position"] = "main"
		data["dungeon_keys"] = 0
		data["first_dialogue_show"] = firstDialogueShow
		data["points"] = points
		data["map_location"] = mapLocation
		data["lake_rune"] = lakeRune
		data["desert_rune"] = desertRune
		data["dark_rune"] = darkRune



		var json = JSON.stringify(data)
		file.store_string(json)
		file.close()
		print("Game saved successfully")

func loadGame():

		if (false):
			print("No sera asi")
			# var http = HTTPRequest.new()
			# add_child(http)
			# http.request_completed.connect(_on_request_completed)
			# var url = "http://localhost:3000/save/getSave/" + email
			# var error = http.request(url)

			# if error != OK:
			# 	print("Error al hacer la solicitud: ", error)
		else:

			var file = FileAccess.open("user://dataGame.json", FileAccess.READ)
			if(file == null):
				return

			var json = file.get_as_text()
			var data = JSON.parse_string(json)

			coins = data["coins"] 
			magic = data["magic"]
			bombs = data["bombs"]
			arrows = data["arrows"]
			health = data["health"]
			max_bombs = data["max_bombs"]
			max_arrows = data["max_arrows"]
			max_health = data["max_health"]
			sword_level = data["sword_level"]
			mapLocation = data["map_location"]
			firstDialogueShow = data["first_dialogue_show"]
			lakeRune = data["lake_rune"]
			desertRune = data["desert_rune"]
			darkRune = data["dark_rune"]
			points = data["points"]

			# El resto de los datos iran cuando se implementen

			file.close()
		print("Game loaded successfully")   

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		var resultado = json.parse(body.get_string_from_utf8())
		if resultado == OK:
			var data = json.data
			print("Partida cargada: ", data)
			coins = data["coins"] 
			magic = data["magic"]
			bombs = data["bombs"]
			arrows = data["arrows"]
			health = data["health"]
			max_bombs = data["max_bombs"]
			max_arrows = data["max_arrows"]
			max_health = data["max_health"]
		else:
			print("Error al parsear JSON")	
	else:
		print("Request failed with response code: ", response_code)
		print("Response body: ", body)

func _on_save_completed(result, response_code, headers, body):
	print("Save status:", response_code)
	print("Respuesta del servidor:", body.get_string_from_utf8())

func obtainData():
	return 	{
			"items": {
				"lantern": true,
				"hook": true,
				"bomb_bag": true,
				"bow": true,
				"ocarina": true,
				"lens_of_truth": true,
				"bottle1": true,
				"bottle2": false,
				"bottle3": false
			},
			"rune_count": 1,
			"sword_level": 2,
			"coins": coins,
			"max_bombs": max_bombs,
			"max_arrows": max_arrows,
			"max_health": max_health,
			"current_position": "main",
			"bombs": bombs,
			"arrows": arrows,
			"health": health,
			"magic": magic,
			"dungeon_keys": 0
		}
