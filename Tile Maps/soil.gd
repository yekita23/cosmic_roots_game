extends Area2D
@onready var soil_tilemap: TileMap =$SoilTileMap 
@onready var inventory_bar:Control =  $"../../UI/InventoryBar"# UI yolunu kendi sahne yapına göre düzelt

# Tile ID sabitleri (TileSet içindeki ID'lere göre ayarla)
const T_NORMAL = 0
const T_HOED = 1
const T_WATERED = 2
const T_PLANTED = 3
const T_GROWN = 4

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = soil_tilemap.local_to_map(mouse_pos)
		var selected_slot = inventory_bar.selected_index

		match selected_slot:
			0:
				till_soil(tile_pos)
			1:
				water_soil(tile_pos)
			2:
				plant_seed(tile_pos)
			3:
				harvest(tile_pos)

func till_soil(tile_pos: Vector2i) -> void:
	var id = soil_tilemap.get_cell_source_id(0, tile_pos)
	if id == T_NORMAL:
		soil_tilemap.set_cell(0, tile_pos, T_HOED)
		print("Çapalandı:", tile_pos)

func water_soil(tile_pos: Vector2i) -> void:
	var id = soil_tilemap.get_cell_source_id(0, tile_pos)
	if id == T_HOED:
		soil_tilemap.set_cell(0, tile_pos, T_WATERED)
		print("Sulandı:", tile_pos)

# TOHUM EKME: tile_pos parametresi ZORUNLU
func plant_seed(tile_pos: Vector2i) -> void:
	var id = soil_tilemap.get_cell_source_id(0, tile_pos)
	if id == T_WATERED:
		soil_tilemap.set_cell(0, tile_pos, T_PLANTED)
		print("Tohum ekildi:", tile_pos)

		# Her ekilen pozisyon için ayrı bir Timer oluştur
		var t = Timer.new()
		t.one_shot = true
		t.wait_time = 5.0   # test için 5s — gerçek oyun için 300.0 (5 dk)
		add_child(t)
		# bağlama: timeout tetiklendiğinde tile_pos ile _on_grow_timeout çağrısı
		t.timeout.connect(Callable(self, "_on_grow_timeout").bind(tile_pos))
		t.start()

# Timer timeout callback — parametre ile tile_pos alıyoruz
func _on_grow_timeout(tile_pos: Vector2i) -> void:
	var id = soil_tilemap.get_cell_source_id(0, tile_pos)
	if id == T_PLANTED:
		soil_tilemap.set_cell(0, tile_pos, T_GROWN)
		print("Büyüdü:", tile_pos)

func harvest(tile_pos: Vector2i) -> void:
	var id = soil_tilemap.get_cell_source_id(0, tile_pos)
	if id == T_GROWN:
		soil_tilemap.set_cell(0, tile_pos, T_NORMAL)
		print("Hasat edildi:", tile_pos)
		# buraya oyun bitişi veya görev tamamlandı çağrısı ekleyebilirsin



































#@onready var soil_tilemap = $SoilTileMap
#@onready var sprite = $Sprite2D
#@onready var grow_timer = $GrowTimer  # Timer node eklemen gerekiyor
#@onready var inventory_bar = $UI/InventoryBar
#var state = "normal" # normal, hoed, watered, planted, grown
#
## Toprak görselleri
#var soil_textures = {
	#"normal": preload("res://soils/normal.png"),
	#"hoed": preload("res://soils/hoed.png"),
	#"watered": preload("res://soils/watered.png"),
	#"planted": preload("res://soils/planted.png"),
	#"grown": preload("res://soils/grown.png"),
#}
#
#
#
#
#
#func till_soil(tile_pos: Vector2i):
	#var current_id = soil_tilemap.get_cell_source_id(0, tile_pos)
	#if current_id == 0: # Sadece normal topraksa
		#soil_tilemap.set_cell(0, tile_pos, 1) # Çapalanmış yap
#
#
#
#
## 0: normal, 1: çapalanmış, 2: sulanmış
##func till_soil(world_pos: Vector2):
	##var tile_pos = soil_tilemap.local_to_map(world_pos)    # veya world_to_map gerekirse dene
	##var current_id = soil_tilemap.get_cell_source_id(0, tile_pos)
	##print("Tıkladı:", tile_pos, "ID:", current_id)
	##if current_id == 0: # normal -> çapalanmış
		##soil_tilemap.set_cell(0, tile_pos, 1)
		##print("Çapalandı")
#
#func _process(delta):
	#if Input.is_action_just_pressed("interact"):
		#var mouse_pos = get_global_mouse_position()
		#var tile_pos = soil_tilemap.local_to_map(mouse_pos)
#
		#var selected_slot = inventory_bar.selected_index
#
		#match selected_slot:
			#0: # Çapa
				#till_soil(tile_pos)
			#1: # Sulama kabı
				#water_soil(tile_pos)
			#2: # Tohum
				#plant_seed(tile_pos)
#
#
#func plant_seed(tile_pos: Vector2i):
	#set_state("planted")
	#grow_timer.start(300) # 5 dakika (300 saniye)
	#soil_tilemap.set_cell(0, tile_pos, 3) # 3 = ekilmiş toprak
#
#
#func water_soil(tile_pos: Vector2i):
	#var current_id = soil_tilemap.get_cell_source_id(0, tile_pos)
	#if current_id == 1: # Sadece çapalanmışsa sulanır
		#soil_tilemap.set_cell(0, tile_pos, 2) # Sulanmış yap
#
#
#
#func _ready():
	#set_state("normal")
#
## Toprak durumunu değiştiren fonksiyon
#func set_state(new_state):
	#state = new_state
	#if soil_textures.has(state):
		#sprite.texture=soil_textures[state]
	#else:
		#print("geçersiz state:"+state)
	#sprite.texture = soil_textures[state]
#
## Oyuncu ile etkileşim
#func interact_with_soil(selected_tool):
	#if selected_tool == "hoe" and state == "normal":
		#set_state("hoed")
	#elif selected_tool == "watering_can" and state == "hoed":
		#set_state("watered")
	#elif selected_tool == "seed" and state == "watered":
		#plant_seed(tile_pos)
	#elif selected_tool == "sickle" and state == "grown":
		#harvest()
#
## Tohum ekme
##func plant_seed():
	##set_state("planted")
	##grow_timer.start(300) # 5 dakika (300 saniye)
#
## Timer dolunca çağrılır → bitki büyür
#func _on_GrowTimer_timeout():
	#set_state("grown")
#
## Hasat
#func harvest():
	#set_state("normal")
	#get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
#
#
#func _on_grow_timer_timeout() -> void:
	#pass # Replace with function body.
