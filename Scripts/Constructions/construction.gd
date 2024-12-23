extends StaticBody2D

# attributes
var hp_base: float = 100.0;
var hp: float = 0.0;

# verifications
var destroyed: bool = true;

# villagers
var player: CharacterBody2D = null;

# distances
var interact_distance: float = 35.0;

func _ready():
	player = find_parent("Village").find_child("Player")
	
func _process(delta):

	# opacity
	if destroyed:
		set_collision_layer_value(4, false);
		if modulate.a > 0.5:
			modulate.a = 0.5;
			
		if player != null:
			# contruction interact
			if global_position.distance_to(player.global_position) <= interact_distance:
				if Input.is_action_just_released("E"):
					hp = hp_base;
					destroyed = false;
	else:
		set_collision_layer_value(4, true);
		if modulate.a < 1:
			modulate.a = 1;
			
		if hp <= 0:
			destroyed = true;
