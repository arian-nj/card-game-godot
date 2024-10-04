extends Node2D

# var _card_scene = preload("res://card.tscn")

var cards_stack:Array[Card] = []

@export var hand_node:Deck
@export var stack_node:Sprite2D

# var distance_between_cards = 40.0
func shuffle_cards():
	var cards_len:int = len(cards_stack)
	var rand_number_of_swaps = randi_range(200,100)
	for i in range(rand_number_of_swaps):
		var a_index = randi_range(0,cards_len-1)
		var b_index = randi_range(0,cards_len-1)
		
		var holder:Card = cards_stack[b_index]
		cards_stack[b_index] = cards_stack[a_index]
		cards_stack[a_index] = holder

func _ready():
	for suit in range(4):
		for value in range(1,14):
			var c := Deck.create_card(suit,value)
			cards_stack.append(c)
			# print(c.get_assets_path())

	shuffle_cards()

	for i in range(13):
		var c:Card = cards_stack.pop_back()
		hand_node.add_card(c,stack_node.global_position)
	
	# _get_cards()


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
