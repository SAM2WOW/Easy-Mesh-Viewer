extends MeshInstance


func _ready():
	var a = mesh.surface_get_arrays(0)
	var m = mesh.surface_get_material(0)
	mesh.surface_remove(0)
	mesh.add_surface_from_arrays(1, a)

	#if there's more than one surface, the surface idx should be the last
	mesh.surface_set_material(0, m)
