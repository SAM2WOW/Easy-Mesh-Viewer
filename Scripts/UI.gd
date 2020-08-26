extends Control


func _init():
	Global.ui_ref = self


func _ready():
	# Set version
	var version_code = ProjectSettings.get("application/config/Version")
	$MarginContainer2/HBoxContainer/Version.set_text("Version " + version_code)


func update_mesh_infos(verts, edges, faces):
	var txt = "Verts: %d | Edges: %d | Faces: %d" % [verts, edges, faces]
	$MarginContainer2/HBoxContainer/Infos.set_text(txt)


func change_loading_visibility(show = true):
	if show:
		$CenterContainer/LoadingBar.show()
	else:
		$CenterContainer/LoadingBar.hide()


func _on_Open_pressed():
	$CenterContainer/FileDialog.popup()


func _on_FileDialog_file_selected(path):
	Global.renderer_ref.open_file(path)


func _on_Light_pressed():
	get_node("../Spatial/WorldEnvironment").get_environment().set_bg_color(Color("fcfcfc"))


func _on_Dark_pressed():
	get_node("../Spatial/WorldEnvironment").get_environment().set_bg_color(Color("121212"))


func _on_Settings2_pressed():
	Global.renderer_ref.reset_viewport()


func _on_Lit_pressed():
	Global.renderer_ref.set_viewport_mode(0)


func _on_Unlit_pressed():
	Global.renderer_ref.set_viewport_mode(1)


func _on_Overdraw_pressed():
	Global.renderer_ref.set_viewport_mode(2)


func _on_Wireframe_pressed():
	Global.renderer_ref.set_viewport_mode(3)
