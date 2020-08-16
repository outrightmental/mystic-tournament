extends PanelContainer


onready var tree: Tree = $Tree


func _ready():
	var root = tree.create_item()
	var team1 = tree.create_item(root)
	var team2 = tree.create_item(root)
	team1.set_selectable(0, false)
	team2.set_selectable(0, false)
	var player11 = tree.create_item(team1)
	var player12 = tree.create_item(team1)
	var player13 = tree.create_item(team1)
	var player14 = tree.create_item(team1)
	var player21 = tree.create_item(team2)
	var player22 = tree.create_item(team2)
	var player23 = tree.create_item(team2)
	var player24 = tree.create_item(team2)
	player11.set_text(0, "Shatur95")
	player12.set_text(0, "Empty slot")
	player13.set_text(0, "Empty slot")
	player14.set_text(0, "Empty slot")
	player21.set_text(0, "Player1")
	player22.set_text(0, "Player2")
	player23.set_text(0, "Empty slot")
	player24.set_text(0, "Empty slot")
	team1.set_text(0, "Team1 (1/4)")
	team2.set_text(0, "Team2 (2/4)")
	var redTexture = ImageTexture.new()
	var greenTexture = ImageTexture.new()
	var blueTexture = ImageTexture.new()
	
	var redImage = Image.new()
	redImage.create(10,10,false,Image.FORMAT_RGB8)
	redImage.fill(Color(1,0,0))

	var greenImage = Image.new()
	greenImage.create(10,10,false,Image.FORMAT_RGB8)
	greenImage.fill(Color(0,1,0))

	var blueImage = Image.new()
	blueImage.create(10,10,false,Image.FORMAT_RGB8)
	blueImage.fill(Color(0,0,1))


	redTexture.create_from_image(redImage)
	greenTexture.create_from_image(greenImage)
	blueTexture.create_from_image(blueImage)

	player11.add_button(0, redTexture)
	player11.add_button(0, greenTexture)
	player11.add_button(0, blueTexture)
