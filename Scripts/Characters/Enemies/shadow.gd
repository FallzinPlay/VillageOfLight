extends "enemies.gd"

func _ready():
	super._ready()
	hp = 50.0;
	dmg = 10.0;
	spd = 100.0;
	
	distance_to_attack = 18.0;


func _on_anim_animation_finished():
	if $Anim.animation == "attack":
		can_attack = true;
