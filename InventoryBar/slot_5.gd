extends TextureRect

@export var slot_index: int = 1 # 1-5 arası
@export var item_name: String = "" # "hoe", "scythe", "watering_can", "seed1", "seed2"

var is_selected = false

func set_selected(selected: bool):
	is_selected = selected
	modulate = Color(1, 1, 1, 1) if selected else Color(0.7, 0.7, 0.7, 1)
