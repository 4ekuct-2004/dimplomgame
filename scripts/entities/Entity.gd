extends CharacterBody2D
class_name Entity

@export var NAME: String = "something"
@export var interaction_radius: Area2D

var can_interaction = true

var interaction_options = {
	"idle_option": idle_interaction
}

func interaction(option: String): 
	if not can_interaction: return
	interaction_options[option].call()

func idle_interaction():
	print("interacted")
