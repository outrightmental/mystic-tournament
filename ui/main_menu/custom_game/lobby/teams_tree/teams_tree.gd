extends Tree


func _ready():
	var root = create_item()

	var team1 = create_item(root)
	var team2 = create_item(root)
	
	team1.set_text(0, "Team 1 (1/4)")
	team2.set_text(0, "Team 2 (1/4)")

	var player11 = create_item(team1)
	var player12 = create_item(team1)
	var player13 = create_item(team1)
	var player14 = create_item(team1)

	var player21 = create_item(team2)
	var player22 = create_item(team2)
	var player23 = create_item(team2)
	var player24 = create_item(team2)

	player11.set_text(0, "Shatur95")
	player12.set_text(0, "Empty slot")
	player13.set_text(0, "Empty slot")
	player14.set_text(0, "Empty slot")

	player21.set_text(0, "Shatur95")
	player22.set_text(0, "Empty slot")
	player23.set_text(0, "Empty slot")
	player24.set_text(0, "Empty slot")
