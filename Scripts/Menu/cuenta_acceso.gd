extends Control

@onready var button_volver = $VBoxContainer/B_Volver
@onready var button_login = $VBoxContainer/B_Login
@onready var button_signup = $VBoxContainer/B_Signup

func volver():
    var menu = get_node("/root/GameMenu/MainMenu")
    var menu_cuenta = get_node("/root/GameMenu/cuenta_acceso")
    menu.visible = true
    menu_cuenta.visible = false

func login():
    var menu = get_node("/root/GameMenu/cuenta_acceso")
    var menu_login = get_node("/root/GameMenu/cuenta_login")
    menu.visible = false
    menu_login.visible = true

func signup():
    var menu = get_node("/root/GameMenu/cuenta_acceso")
    var menu_signup = get_node("/root/GameMenu/cuenta_register")
    menu.visible = false
    menu_signup.visible = true