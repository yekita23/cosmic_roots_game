extends Area2D
@onready var soil_tilemap = $SoilTileMap
@onready var sprite = $Sprite2D
@onready var grow_timer = $GrowTimer  # Timer node eklemen gerekiyor

var state = "normal" # normal, hoed, watered, planted, grown

# Toprak görselleri
var soil_textures = {
	"normal": preload("res://soils/normal.png"),
	"hoed": preload("res://soils/hoed.png"),
	"watered": preload("res://soils/watered.png"),
	"planted": preload("res://soils/planted.png"),
	"grown": preload("res://soils/grown.png"),
}

# 0: normal, 1: çapalanmış, 2: sulanmış
func till_soil(pos):
	var tile_pos = soil_tilemap.local_to_map(pos)
	soil_tilemap.set_cell(0, tile_pos, 1)  # 1 = çapalanmış tile



func _ready():
	set_state("normal")

# Toprak durumunu değiştiren fonksiyon
func set_state(new_state):
	state = new_state
	if soil_textures.has(state):
		sprite.texture=soil_textures[state]
	else:
		print("geçersiz state:"+state)
	sprite.texture = soil_textures[state]

# Oyuncu ile etkileşim
func interact_with_soil(selected_tool):
	if selected_tool == "hoe" and state == "normal":
		set_state("hoed")
	elif selected_tool == "watering_can" and state == "hoed":
		set_state("watered")
	elif selected_tool == "seed" and state == "watered":
		plant_seed()
	elif selected_tool == "sickle" and state == "grown":
		harvest()

# Tohum ekme
func plant_seed():
	set_state("planted")
	grow_timer.start(300) # 5 dakika (300 saniye)

# Timer dolunca çağrılır → bitki büyür
func _on_GrowTimer_timeout():
	set_state("grown")

# Hasat
func harvest():
	set_state("normal")
	get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")


func _on_grow_timer_timeout() -> void:
	pass # Replace with function body.
