extends CharacterBody2D

var spd: float = 150.0;
var dir: Vector2 = Vector2.ZERO;
var dmg: float = 0.0;

func _physics_process(delta):
	if dir != Vector2.ZERO:
		velocity = dir * spd * delta * 100;
		
	var collide = get_last_slide_collision();
	if collide:
		var collisor = collide.get_collider();
		if collisor is CharacterBody2D:
			collisor.hp -= dmg;
			print(collisor.hp)
			queue_free();
		
	move_and_slide()
