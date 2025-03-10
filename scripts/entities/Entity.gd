extends CharacterBody2D
class_name Entity

@export var NAME: String = "entity"
@export var interaction_radius: Area2D
@export var interaction_options: Dictionary

var can_interaction = true

func _ready() -> void:
	interaction_options = {
		"idle_option": idle_interaction
	}

func interaction(option: String): 
	if not can_interaction: return
	interaction_options[option].call()

func idle_interaction():
	print("interacted")
