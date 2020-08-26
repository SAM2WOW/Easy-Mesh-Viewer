extends Spatial

var obj_parser = preload("res://Scripts/ObjParse.gd")

var sensitivity = 0.01

var rot_down = false
var pan_down = false


func _init():
	Global.renderer_ref = self
	
	# Enable Visual Server
	VisualServer.set_debug_generate_wireframes(true)


func _ready():
	# Check for auto opening
	# yield(get_tree().create_timer(0.01), "timeout")
	var address = OS.get_cmdline_args()
	
	print(address)
	
	if address.size() > 0:
		open_file(address[0])
	


func _input(event):
	if event.is_action_pressed("rotate"):
		rot_down = true
	elif event.is_action_released("rotate"):
		rot_down = false
	
	if event.is_action_pressed("pan"):
		pan_down = true
	elif event.is_action_released("pan"):
		pan_down = false
	
	if event is InputEventMouseMotion:
		if rot_down:
			$CameraArm.rotate_object_local(Vector3.DOWN, event.relative.x * sensitivity)
			$CameraArm.rotate_object_local(Vector3.LEFT, event.relative.y * sensitivity)
		if pan_down:
			$CameraArm/Camera.translate_object_local(Vector3(-event.relative.x * sensitivity, event.relative.y * sensitivity, 0))
	
	if event.is_action_pressed("zoom_in"):
		if $CameraArm/Camera.translation.z > 0:
			$CameraArm/Camera.translation.z -= 1
			$CameraArm/Camera.fov -= 10
	
	if event.is_action_pressed("zoom_out"):
		$CameraArm/Camera.translation.z += 1
		$CameraArm/Camera.fov += 10


func set_viewport_mode(mode):
	var vp = get_viewport()
	vp.debug_draw = mode


func open_file(path):
	match (path.get_extension()):
		"obj":
			load_model_obj(path)
		"dae":
			pass
		"fbx":
			#load_model_fbx(path)
			pass
		"gltf":
			pass


func load_model_obj(path):
	clean_stage()
	reset_viewport()
	
	Global.ui_ref.change_loading_visibility(true)
	yield(get_tree().create_timer(0.01), "timeout")
	
	var mesh_instance = MeshInstance.new()
	
	var address = path.get_basename()
	var dir = Directory.new()
	var mesh = Mesh.new()
	
	# Check if mtl file exist
	if dir.file_exists(address + ".mtl"):
		mesh = obj_parser.new().parse_obj(address + ".obj", address + ".mtl")
	else:
		mesh = obj_parser.new().parse(address + ".obj")
	
	# Add mesh
	mesh_instance.set_mesh(mesh)
	$Objects.add_child(mesh_instance)
	
	# Auto size
	var size = 1.0 / (mesh.get_aabb().get_longest_axis_size() / 4.0)
	mesh_instance.set_scale(Vector3(size, size, size))
	
	# Add mesh infos
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	Global.ui_ref.update_mesh_infos(mdt.get_vertex_count(), mdt.get_edge_count(), mdt.get_face_count())
	
	Global.ui_ref.change_loading_visibility(false)


func load_model_fbx(path):
	clean_stage()
	reset_viewport()

	Global.ui_ref.change_loading_visibility(true)
	yield(get_tree().create_timer(0.01), "timeout")
	
	#var mesh_instance = MeshInstance.new()
	var mesh = ResourceLoader.load(path).instance()

	#mesh_instance.set_mesh(mesh)
	$Objects.add_child(mesh)
	
	Global.ui_ref.change_loading_visibility(false)


func clean_stage():
	for i in $Objects.get_children():
		i.queue_free()


func reset_viewport():
	$CameraArm.set_rotation(Vector3.ZERO)
	$CameraArm/Camera.set_translation(Vector3(0, 0, 6))
	$CameraArm/Camera.set_fov(70.0)
