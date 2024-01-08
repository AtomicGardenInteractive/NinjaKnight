extends Node

@export var initial_enemystate : EnemyState
@export var parent : Enemy = null

var current_enemystate : EnemyState
var enemystates : Dictionary = {}


func _ready():
	parent = self.get_parent()
	for child in get_children():
		if child is EnemyState:
			enemystates[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.parent = parent
	
	if initial_enemystate:
		initial_enemystate.enter()
		current_enemystate = initial_enemystate

func _process(delta):
	if current_enemystate:
		current_enemystate.Update(delta)

func _physics_process(delta):
	if current_enemystate:
		current_enemystate.Physics_Update(delta)

func on_child_transition(enemystate, new_state_name):
	print(enemystate.name + " vs. " + current_enemystate.name)
	if enemystate != current_enemystate:
		return
	var new_enemystate = enemystates.get(new_state_name.to_lower())
	if !new_enemystate:
		return
	
	if current_enemystate:
		current_enemystate.exit()
	
	current_enemystate = new_enemystate
	
	new_enemystate.enter()
