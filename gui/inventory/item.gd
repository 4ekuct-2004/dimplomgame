extends Node2D
class_name Item

var item_ranks = {
	5: Color.GRAY,
	4: Color.WHITE,
	3: Color.GREEN,
	2: Color.YELLOW,
	1: Color.RED,
	0: Color.BLACK
}

var item_name = "noname"
var item_desc = "nothing"
var rank: int

var icon: Texture2D
