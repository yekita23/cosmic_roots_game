extends Control

@onready var slots = [
	$Slot1,
	$Slot2,
	$Slot3,
	$Slot4,
	$Slot5
]

var selected_index = 0

func _ready():
	select_slot(0) # oyuna başlarken ilk slot seçili

func _process(delta):
	# 1-5 tuşlarıyla slot seçme
	for i in range(5):
		if Input.is_action_just_pressed("select_" + str(i+1)):
			select_slot(i)

func select_slot(index):
	selected_index = index
	for i in range(len(slots)):
		slots[i].set_selected(i == index)
