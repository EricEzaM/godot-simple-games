extends Node
# Docstring

# --- Signals
# --- Enums
# --- Constants
# --- Exported Variables

export (PackedScene) var main_menu_pck_scn: PackedScene
export (PackedScene) var configuration_pck_scn: PackedScene
export (PackedScene) var game_pck_scn: PackedScene

# --- Public Variables

var main_menu: String
var configuration: String
var game: String

# --- Private Variables
# --- Onready Variables

func _ready():
	main_menu = main_menu_pck_scn.resource_path
	configuration = configuration_pck_scn.resource_path
	game = game_pck_scn.resource_path
	pass

# --- Virtual Override methods
# --- Public Methods
# --- Private Methods
