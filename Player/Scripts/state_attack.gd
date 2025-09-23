class_name State_Attack extends State
var attacking:bool=false
@onready var walk:State=$"../Walk"
@onready var animation_player:AnimationPlayer= $"../../AnimationPlayer"
@onready var idle:State=$"../Idle"
#@onready var attack_anim:AnimationPlayer=$"../../Sprite2D/AttackEffectSprite/AnimationPlayer"


func Enter() -> void:
	player.UpdateAnimation("attack")
	#attack_anim.play("attack_" +player.AnimDirection())
	animation_player.animation_finished.connect(EndAttack)
	attacking=true
	pass


func _exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking=false
	pass

func Process(delta: float) -> State:
	#if player.direction != Vector2.ZERO:
		#return walk
 
	player.velocity=Vector2.ZERO
	if attacking==false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null



func Physics(delta: float) -> State:
	return null
	
	
	
	
func HandleInput(_event:InputEvent)->State:
	return null

func EndAttack()->void:
	attacking=false
