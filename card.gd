class_name Card extends Button

signal card_played(card:Card,move_delta:Vector2)

@export var txrect:TextureRect

enum CardSuites {
	Diamonds,
	Clubs,
	Hearts,
	Spades
}

var choosed = false
var start_choosed_pos:Vector2 
var end_choosed_pos:Vector2

@export var suit :CardSuites
@export var value:int

func _process(_delta):
	if choosed:
		global_position = get_global_mouse_position()
		global_position.x -= size.x
		global_position.y -= size.y*2

func suite_name() -> String:
	var sname = ""

	match suit:
		CardSuites.Clubs:
			sname ="clubs"
		CardSuites.Diamonds:
			sname ="diamonds"
		CardSuites.Hearts:
			sname ="hearts"
		CardSuites.Spades:
			sname ="spades"
	
	return sname

func value_name() -> String:
	match value:
		11:return "J"
		12:return "Q"
		13:return "K"
		1:return "A"
		_:return str(value)

func get_assets_path() -> String:
	return "res://card-assets/PNG/Cards (large)/card_"+suite_name()+"_"+value_name()+".png"

func _ready():
	var file = get_assets_path()
	var img = load(file)
	txrect.texture = img

func _on_button_up() -> void:
	choosed = false
	end_choosed_pos = global_position
	var move_delta = start_choosed_pos - end_choosed_pos
	card_played.emit(self,move_delta)
	modulate = Color8(255,255,255)

func _on_button_down() -> void:
	choosed = true
	start_choosed_pos = global_position
	modulate = Color8(0,255,0)
