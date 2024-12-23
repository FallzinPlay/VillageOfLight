extends CharacterBody2D

# attributes
var hp: float = 0.0;
var dmg: float = 0.0;
var spd: float = 0.0;
var dir: int = 1;

# conditions
var can_attack: bool = false;

# state
enum State {
	IDLE,
	RUN,
	ATTACK,
	DEATH,
};
var state: State = State.IDLE;

# target
var target: StaticBody2D = null;

# constructions
var constructions: Array = [];

# distances
var distance_to_target: float = 0.0;
var distance_to_attack: float = 0.0;

# timers
var attack_timer: float = 1.2;
var attack_count: float = 0.0;

# gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	constructions = find_parent("Village").find_child("Construction").get_children();
	attack_count = attack_timer;

func _physics_process(delta):
	if !constructions.is_empty() and constructions != null:

		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta;

		if hp <= 0:
			state = State.DEATH;

		if target == null:
			# get the constructions no destroyed
			var no_destroyed: Array = [];
			for c in constructions:
				if !c.destroyed:
					no_destroyed.append(c);
			
			# set the nearest construction
			if no_destroyed != null and !no_destroyed.is_empty():
				var _nearest: StaticBody2D = no_destroyed[0];
				
				for c in no_destroyed:
					if global_position.distance_to(c.global_position) < global_position.distance_to(_nearest.global_position):
						_nearest = c;
						
				if _nearest != null and !_nearest.destroyed:
					target = _nearest;
					dir = sign(global_position.distance_to(target.global_position));
					if dir == 0:
						dir = 1;
					state = State.RUN;
		else:
			distance_to_target = global_position.distance_to(target.global_position);
			
			if state != State.ATTACK:
				if attack_count >= attack_timer:
					if distance_to_target <= distance_to_attack:
						attack_count = 0;
						$Anim.play("attack");
						state = State.ATTACK;
				attack_count += delta;
			
			match state:
				State.IDLE:
					$Anim.play("idle");
					
				State.RUN:
					velocity.x = spd * delta * dir * 80.0;
					$Anim.scale.x = dir;
					
				State.ATTACK:
					velocity.x = move_toward(velocity.x, 0, spd * delta * 80.0);
					
					if can_attack:
						target.hp -= dmg;
						print(target.hp);
						can_attack = false;
						state = State.IDLE;
					
				State.DEATH:
					queue_free();
					
			if target.destroyed:
				target = null;
				state = State.IDLE;
		
		move_and_slide()

# states
func _idle() -> void:
	pass

func _run() -> void:
	pass
	
func _attack() -> void:
	pass
