extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cards: Array = $CardContainer.get_children()
@onready var effects: Array = ["Gladiator", "Fortify", "Flash"]
@onready var gold_border = preload("res://UI/card_outline_gold.png")
@onready var white_border = preload("res://UI/card_outline_white.png")
var player: Player

var rareCardBonus: int = 10
var strength: int
var agility: int
var defense: int

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	randomizeCards()	
	animation_player.play("Canvas_Title")
	await animation_player.animation_finished
	makeCardsFloat()

func freeze_game():
	get_tree().paused = true
	
func _on_pressed():
	match find_child("Card_Title").text:
		"Gladiator":
			player.playerData.tempSTR = strength
			player.playerData.Strength += player.playerData.tempSTR
		"Fortify":
			player.playerData.tempDEF = defense
			player.playerData.Defense += player.playerData.tempDEF
		"Flash":
			player.playerData.tempAGI = agility
			player.playerData.Agility += player.playerData.tempAGI
	self.visible = false
	get_tree().paused = false
	
func randomizeCards():
	effects.shuffle()  # Shuffle the effects array to randomize order
	for i in range(min(cards.size(), effects.size())):  # Use min to ensure we don't go out of bounds
		var card = cards[i]
		var cardBG = card.get_node("Card_Background")
		var cardTitle = card.get_node("Card_Title")
		var cardDescription = card.get_node("Card_Description")
		var cardIcon = card.get_node("Card_Icon")
		var cardStats = card.get_node("Card_Stats")
		
		cardTitle.text = effects[i]  # Assign shuffled effect to the card
		
		var cardBonus = randi_range(10, 25)
		
		# Use 'match' on the assigned effect string
		match effects[i]:
			"Gladiator":
				cardIcon.frame = 2
				cardDescription.text = "Become enraged from endlessly slaying monsters with no end in sight."
				cardStats.text = "STR + " + str(cardBonus)
				cardBG.set_texture(white_border)
				strength = cardBonus
			"Fortify":
				cardIcon.frame = 6
				cardDescription.text = "Inherit the blessing of the God of Defense Claytonic."
				cardStats.text = "DEF + " + str(cardBonus + rareCardBonus)
				cardBG.set_texture(gold_border)
				defense = cardBonus + rareCardBonus
			"Flash":
				cardIcon.frame = 1
				cardDescription.text = "Become one with the wind and unlock your latent potential for speed and agility."
				cardStats.text = "AGI + " + str(cardBonus)
				cardBG.set_texture(white_border)
				agility = cardBonus
				
func makeCardsFloat():
	var cardContainer = $CardContainer
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cardContainer, "position", Vector2(cardContainer.position.x, cardContainer.position.y + 2), 1)
	tween.tween_property(cardContainer, "position", Vector2(cardContainer.position.x, cardContainer.position.y - 2), 1)
	tween.set_loops()
