extends Node3D

enum LEVELS {
  MAIN_MENU,
  LEVEL_0,
  LEVEL_1,
}

const LEVEL_PATHS: Dictionary = {
  LEVELS.MAIN_MENU: "res://ui/main_menu.tscn",
  LEVELS.LEVEL_0: "res://levels/level_0/level_0.tscn",
  LEVELS.LEVEL_1: "res://levels/level_1/level_1.tscn",
}

const LEVEL_TRANSITIONS: Dictionary = {
  LEVELS.LEVEL_0: LEVELS.LEVEL_1,
  LEVELS.LEVEL_1: null,  # Fin del juego
}

@onready var current_level_node = $CurrentLevel

var current_level_path: String = LEVEL_PATHS[LEVELS.MAIN_MENU]
var current_level_id: LEVELS = LEVELS.MAIN_MENU

func _ready():
	if not current_level_node:
		push_error("current_level_node is null")
		return
	if victory_ui:
		victory_ui.visible = false
	if death_ui:
		death_ui.visible = false
	load_level(current_level_path)

func load_level(level_path: String):
	# Ocultar UIs
	if death_ui:
		death_ui.visible = false
	if victory_ui:
		victory_ui.visible = false
	# Remover nivel actual si existe
	for child in current_level_node.get_children():
		child.queue_free()

	# Cargar y instanciar nuevo nivel
	var level_scene = load(level_path)
	if level_scene:
		var level_instance = level_scene.instantiate()
		current_level_node.add_child(level_instance)
		current_level_path = level_path

		# Actualizar current_level_id
		for id in LEVEL_PATHS.keys():
			if LEVEL_PATHS[id] == level_path:
				current_level_id = id
				break

		# Conectar señales
		var treasure_chest = level_instance.get_node_or_null("TreasureChest")
		if treasure_chest:
			treasure_chest.connect("victory", Callable(self, "victory"))
		var player = level_instance.get_node_or_null("Player")
		if player:
			player.player_died.connect(Callable(self, "on_player_died"))
	else:
		push_error("No se pudo cargar el nivel: " + level_path)

func change_to_level(level_id: LEVELS):
	load_level(LEVEL_PATHS[level_id])

# Funciones para menús, asumiendo escenas en ui/
func go_to_main_menu():
	load_level(LEVEL_PATHS[LEVELS.MAIN_MENU])

func start_game():
	load_level(LEVEL_PATHS[LEVELS.LEVEL_0])

# Para transiciones futuras, agregar señales o animaciones

@onready var victory_ui = $CanvasLayer/VictoryControl
@onready var death_ui = $CanvasLayer/DeathUI
var game_finished = false

# Crea una señal que reciba con argumento del proximo nivel
signal next_level(level_id)

func on_player_died(last_damage: Vector3):
	var player = get_tree().get_nodes_in_group("player")[0]
	player.is_dead = true
	if death_ui:
		death_ui.visible = true
	var death_state = PlayerStateMachine.State.DEATH_FORWARD
	if last_damage.x < player.global_position.x:
		death_state = PlayerStateMachine.State.DEATH_BACKWARD
	player.state_machine.update_state_forced(death_state)
	AudioManager.change_music(AudioManager.TRACKS.LOOP_TECHNO_2)

func victory():
	if game_finished: return
	game_finished = true
	var next_level = LEVEL_TRANSITIONS.get(current_level_id, null)
	if next_level != null:
		change_to_level(next_level)
		game_finished = false
		if victory_ui:
			victory_ui.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		var player = get_tree().get_nodes_in_group("player")[0]
		player.game_finished = false
		player.set_physics_process(true)
		player.state_machine.update_state_forced(PlayerStateMachine.State.IDLE)
	else:
		if victory_ui:
			victory_ui.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var player = get_tree().get_nodes_in_group("player")[0]
		player.game_finished = true
		player.set_physics_process(false)
		player.state_machine.update_state_forced(PlayerStateMachine.State.IDLE)
