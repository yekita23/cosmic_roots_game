class_name Player extends CharacterBody2D
var selected_tool = "hoe" # Varsayılan olarak çapa
var inventory = ["hoe", "watering_can", "seed", "sickle"]
var cardinal_direction:Vector2=Vector2.DOWN
var direction : Vector2=Vector2.ZERO

@onready var inventory_bar = $"../UI/InventoryBar"
@onready var animation_player :AnimationPlayer=$AnimationPlayer
@onready var sprite :Sprite2D=$Sprite2D
@onready var state_machine :PlayerStateMachine=$StateMachine

func _ready():
	state_machine.Initialize(self)
	pass


func get_active_item():
	var active_slot = inventory_bar.selected_index
	match active_slot:
		0: return "hoe"          # çapa
		1: return "scythe"       # çırpan
		2: return "watering_can" # sulama kabı
		3: return "seed1"        # bitki 1
		4: return "seed2"        # bitki 2
		_: return ""





func _process(delta):
	if Input.is_action_just_pressed("ui_select_1"):
		selected_tool = inventory[0]
	elif Input.is_action_just_pressed("ui_select_2"):
		selected_tool = inventory[1]
	elif Input.is_action_just_pressed("ui_select_3"):
		selected_tool = inventory[2]
	elif Input.is_action_just_pressed("ui_select_4"):
		selected_tool = inventory[3]
	# Etkileşim tuşu (örneğin 'E')
	if Input.is_action_just_pressed("interact"):
		interact_with_soil()

	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction=Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
	
	pass




func interact_with_soil():
	var soil = get_overlapping_soil()
	
	if soil:
		soil.interact_with_soil(selected_tool)

func get_overlapping_soil():
	var space = get_world_2d().direct_space_state
	
	# Yeni parametre objesi oluştur
	var params = PhysicsPointQueryParameters2D.new()
	params.position = global_position
	params.collide_with_areas = true
	params.collide_with_bodies = true

	# Çarpışma sorgusunu çalıştır
	var result = space.intersect_point(params, 1)
	
	for item in result:
		if item.collider.is_in_group("soil"):
			return item.collider
	return null



func _physics_process(delta):
	move_and_slide()

func SetDirection() -> bool:
	var new_dir: Vector2 = cardinal_direction
	if direction==Vector2.ZERO:
		return false
	if direction.y==0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x==0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction=new_dir
	sprite.scale.x=-1 if cardinal_direction==Vector2.LEFT else 1
	
	
	
	return true



func UpdateAnimation(state:String) -> void:
	animation_player.play(state +"_"+ AnimDirection())
	pass
	
func AnimDirection() -> String:
	if cardinal_direction==Vector2.DOWN:
		return "down"
	elif cardinal_direction==Vector2.UP:
		return "up"
	else: 
		return "side"
