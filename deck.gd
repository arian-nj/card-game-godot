@tool
class_name Deck extends Control


@export var deck_max_card_size:int = 13

var cards : Array[Card] = []

var distance_between_cards = 60.0
var pixel_to_move = distance_between_cards/2

func add_card(c:Card,spawn_from:Vector2):
	cards.append(c)
	c.global_position = spawn_from
	c.card_played.connect(_card_played)

	sort_cards()
	move_cards(0,true)

func _card_played(card:Card,move_delta:Vector2):
	if move_delta.y > 250:
		cards.erase(card)
		card.queue_free()
		sort_cards()
		move_cards(0,true)
	else :
		sort_cards()
		move_cards(0,false)
		

var all_cards_sorted:bool = true


func move_cards(from:int, wait:bool):
	all_cards_sorted = false
	re_assign_z_index()
	for card_index in range(len(cards)):
		var card = cards[card_index]
		if card_index < from:
			continue

		var target_pos = (
			Vector2((card_index)*pixel_to_move,0)
		)

		# card.create_tween().tween_property(
		#     card,"position:x",card.position.x - pixel_to_move,0.01
		# )
		if wait:
			await create_tween().tween_property(
					card,
					"position",
					target_pos,
					0.05
				).finished
		else:
			create_tween().tween_property(
					card,
					"position",
					target_pos,
					0.05
				).finished
				
	
	all_cards_sorted = true


func re_assign_z_index():
	for card_index in range(len(cards)):
		var card = cards[card_index]
		card.z_index = card_index


func sort_deck_suits(suits: Array[Card.CardSuites]) -> Array[Card.CardSuites]:
	var red_suits: Array[Card.CardSuites] = []
	var black_suits: Array[Card.CardSuites] = []
	
	# Separate red and black suits
	for suit in suits:
		if suit == Card.CardSuites.Diamonds or suit == Card.CardSuites.Hearts:
			red_suits.append(suit)
		else:
			black_suits.append(suit)

	# Create a new array to hold the sorted suits
	var sorted_array: Array[Card.CardSuites] = []
	
	# Determine the maximum length for interleaving
	var max_length = max(red_suits.size(), black_suits.size())
	
	# Interleave red and black suits
	for i in range(max_length):
		if black_suits.size() > red_suits.size():
			if i < black_suits.size():
				sorted_array.append(black_suits[i])
			if i < red_suits.size():
				sorted_array.append(red_suits[i])
		else:
			if i < red_suits.size():
				sorted_array.append(red_suits[i])
			if i < black_suits.size():
				sorted_array.append(black_suits[i])
		
	return sorted_array


var in_deck_suites:Array[Card.CardSuites] = []

func sort_cards():

	in_deck_suites = []

	for card in cards:
		if in_deck_suites.has(card.suit) == false:
			in_deck_suites.append(card.suit)
	
	if len(cards) <= 2:
		return
	
	in_deck_suites = sort_deck_suits(in_deck_suites)

	# for card in cards
	cards.sort_custom(value_sort)
	cards.sort_custom(suite_sort)

	for card in cards:
		self.remove_child(card)
	
	
	for card:Card in cards:
		self.add_child(card)
	re_assign_z_index()
	
	

func suite_sort(a:Card,b:Card):
	var a_suite_index = in_deck_suites.find(a.suit)
	var b_suite_index = in_deck_suites.find(b.suit)

	if a_suite_index < b_suite_index:
		return true
	return false

func value_sort(a:Card,b:Card):

	if a.value < b.value:
		return true
	return false

static func create_card(suit:Card.CardSuites,value:int) -> Card:
	var _card_scene = preload("res://card.tscn")
	var card := _card_scene.instantiate() as Card
	card.suit = suit
	card.value = value
	return card
