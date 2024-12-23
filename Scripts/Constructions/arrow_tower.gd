extends "construction.gd"

var target: CharacterBody2D = null;
var enemies: Array = [];

var distance_to_attack: float = 50.0;

var attack_timer: float = 2.0;
var attack_count: float = 0.0;

var dmg: float = 15.0;

func _ready():
	super._ready();
	
	enemies = find_parent("Village").find_child("Enemies").get_children();
	attack_count = attack_timer;

func _process(delta):
	super._process(delta);
	
	if !destroyed:
		if target == null:
			if enemies != null and !enemies.is_empty():
				# get the constructions no destroyed
				var on_close: Array = [];
				for e in enemies:
					if e != null:
						if global_position.distance_to(e.global_position) <= distance_to_attack:
							on_close.append(e);
				
				# set the nearest construction
				if on_close != null and !on_close.is_empty():
					var _nearest: CharacterBody2D = on_close[0];
					
					for e in on_close:
						if global_position.distance_to(e.global_position) < global_position.distance_to(_nearest.global_position):
							_nearest = e;
							
					if _nearest != null:
						target = _nearest;
		else:
			attack_count += delta;
			
			if attack_count >= attack_timer:
				var _arrow = load("res://Scenes/Projectiles/arrow.tscn").instantiate();
				_arrow.position = $Point.global_position;
				find_parent("Village").find_child("Projectiles").add_child(_arrow);
				_arrow.dir = (target.global_position - $Point.global_position).normalized();
				_arrow.dmg = dmg;
				attack_count = 0;
