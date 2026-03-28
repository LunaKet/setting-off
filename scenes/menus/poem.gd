extends MarginContainer

@onready var poem_piece_1: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_1/poem_piece_1
@onready var poem_piece_2: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_1/poem_piece_2
@onready var poem_placehold_1: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_1/poem_placehold_1
@onready var poem_placehold_2: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_1/poem_placehold_2
@onready var poem_piece_3: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_2/VBoxContainer2/poem_piece_3
@onready var poem_piece_4: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_2/VBoxContainer2/poem_piece_4
@onready var poem_placehold_3: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_2/VBoxContainer2/poem_placehold_3
@onready var poem_placehold_4: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_2/VBoxContainer2/poem_placehold_4
@onready var poem_piece_5: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_3/VBoxContainer2/poem_piece_5
@onready var poem_piece_6: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_3/VBoxContainer2/poem_piece_6
@onready var poem_placehold_5: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_3/VBoxContainer2/poem_placehold_5
@onready var poem_placehold_6: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_3/VBoxContainer2/poem_placehold_6
@onready var poem_piece_7: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_4/VBoxContainer2/poem_piece_7
@onready var poem_piece_8: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_4/VBoxContainer2/poem_piece_8
@onready var poem_placehold_7: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_4/VBoxContainer2/poem_placehold_7
@onready var poem_placehold_8: RichTextLabel = $ScrollContainer/VBoxExtras3/stanza_4/VBoxContainer2/poem_placehold_8

var poem_placeholder := []
var poem_true := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	States.found_poem_sig.connect(_update_poems)
	poem_placeholder = [poem_placehold_1, poem_placehold_2,poem_placehold_3,poem_placehold_4,poem_placehold_5,poem_placehold_6,poem_placehold_7,poem_placehold_8]
	poem_true = [poem_piece_1, poem_piece_2, poem_piece_3, poem_piece_4, poem_piece_5, poem_piece_6, poem_piece_7, poem_piece_8]
		
func _update_poems(index):
	for i in range(0,8):
		if States.poem_pieces[i]:
			poem_placeholder[i].hide()
			poem_true[i].show()
		else:
			poem_placeholder[i].show()
			poem_true[i].hide()
