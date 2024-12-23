extends CharacterBody2D

# player settings
var player_name: String = "";

# attributes
var speed: float = 120.0;
var jump: float = 200.0;

# gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta;
	else:
		# jump
		if Input.is_action_just_pressed("Space"):
			velocity.y = jump * -1
		
	# side view movement
	var direction = Input.get_axis("A", "D");
	var move_force: float = speed * delta * 100.0
	if direction != 0:
		$Anim.scale.x = sign(direction);
		velocity.x = move_force * direction;
	else:
		velocity.x = move_toward(velocity.x, 0, move_force)
	
	move_and_slide()
