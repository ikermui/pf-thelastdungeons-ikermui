extends Node

var dataNode
var dungeonKeys = 0
var showDungeonKeys = false
var killedBoss = false
var tony_helped = false

func check_coins(coins) -> bool:
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.coins >= coins:
		return true
	else:
		return false

func help_tony():
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.coins -= 900
	tony_helped = true

func buy_arrows(arrows, coins):
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.arrows += arrows
	dataNode.coins -= coins

func buy_bombs(bombs, coins):
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.bombs += bombs
	dataNode.coins -= coins

func check_bombs() -> bool:
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.bombs < dataNode.max_bombs:
		return true
	else:
		return false

func check_arrows() -> bool:
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.arrows < dataNode.max_arrows:
		return true
	else:
		return false

func check_sword_level() -> bool:
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.sword_level < 3:
		return true
	else:
		return false

func improve_sword(coins):
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.sword_level < 3:
		dataNode.sword_level += 1
		dataNode.coins -= coins
		return true
	else:
		return false

func health_player(coins):
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.coins -= coins
	dataNode.health = dataNode.max_health


func magic_player(coins):
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.coins -= coins
	dataNode.magic += 100

func heal_player(coins):
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.coins -= coins
	dataNode.health = dataNode.max_health
	dataNode.magic += 100

func add_key():
	dungeonKeys += 1

func get_keys() -> int:
	return dungeonKeys

func remove_key():
	if dungeonKeys > 0:
		dungeonKeys -= 1
		return true
	else:
		return false

func show_dungeon_keys():
	showDungeonKeys = true

func hide_dungeon_keys():
	showDungeonKeys = false

func boss_killed():
	killedBoss = true

func revert_boss_killed():
	killedBoss = false

func check_lake():
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.lakeRune:
		return true
	else:
		return false

func check_desert():
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.desertRune:
		return true
	else:
		return false

func check_dark():
	dataNode = get_node("/root/MainRoom/DataController")
	if dataNode.darkRune:
		return true
	else:
		return false