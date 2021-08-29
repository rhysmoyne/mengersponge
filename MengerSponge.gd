extends Spatial

var cube = load("res://Cube.tscn")

#onready var sponges = [get_node("Sponge/MeshInstance")]
var sponges = [0]
var scales = [1]
var MAX_CUBES = 200_000
var count = 0
var ROTATE_SPEED = 0.5

func _ready():
	$Sponge/MultiMeshInstance.multimesh.instance_count = MAX_CUBES
	$Sponge/MultiMeshInstance.multimesh.visible_instance_count = MAX_CUBES
	
	# hide all the boxes except index 0
	for i in range(1,MAX_CUBES):
			var moved_t = $Sponge/MultiMeshInstance.multimesh.get_instance_transform(i)
			moved_t = moved_t.translated(Vector3(1000, 1000, 1000))
			$Sponge/MultiMeshInstance.multimesh.set_instance_transform(i, moved_t)
	
	
func generate(current_cube):
	var boxes = []
	#var count = current_cube
	for x in range(-1, 2, 1):
		for y in range(-1, 2, 1):
				for z in range(-1, 2, 1):
					var sum = abs(x) + abs(y) + abs(z)
					var new_size = scales[current_cube] / 3.0
					
					#print(new_size)
					
					if (sum > 1):

						#print($Sponge/MultiMeshInstance.multimesh.visible_instance_count)
						
						#var transform = $Sponge/MultiMeshInstance.multimesh.get_instance_transform(current_cube)
						var transform = Transform.IDENTITY
						#print(transform)
						#var transform = Transform()
						#var new_cube = cube.instance()
						var current_cube_t = $Sponge/MultiMeshInstance.multimesh.get_instance_transform(current_cube).origin
						var current_x = current_cube_t.x
						var current_y = current_cube_t.y
						var current_z = current_cube_t.z
						#print(current_cube)
						#print(current_x, current_y, current_z)
						#new_cube.scale = (Vector3(new_size, new_size, new_size))


						transform = transform.translated((Vector3(current_x+x*new_size, current_y+y*new_size, current_z+z*new_size)))
						#transform = transform.scaled(Vector3(new_size, new_size, new_size))
						transform.basis = transform.basis.scaled(Vector3(new_size, new_size, new_size))
						#transform = transform.translated(Vector3(randf() * 100 - 5, 0, 0))
						#new_cube.translation = (Vector3(current_x+x*new_size, current_y+y*new_size, current_z+z*new_size))

						count = count + 1
						#$Sponge/MultiMeshInstance.multimesh.visible_instance_count += 1
						$Sponge/MultiMeshInstance.multimesh.set_instance_transform(count, transform)
						#print(transform)
						#$Sponge.add_child(new_cube)
						boxes.append(count)
						scales.append(new_size)

										
	return boxes
					
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var next = []
		for box in sponges:
			var new_box = generate(box)
			next.append_array(new_box)
		for sponge in sponges:
			var moved_t = $Sponge/MultiMeshInstance.multimesh.get_instance_transform(sponge)
			moved_t = moved_t.translated(Vector3(1000, 1000, 1000))
			$Sponge/MultiMeshInstance.multimesh.set_instance_transform(sponge, moved_t)
		#	sponge.queue_free()
		sponges = next


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sponge.rotate_y(ROTATE_SPEED * delta)
	$Sponge.rotate_x(ROTATE_SPEED * delta)
	$Sponge.rotate_z(ROTATE_SPEED * delta)
	OS.set_window_title("fps: " + str(Engine.get_frames_per_second()))

