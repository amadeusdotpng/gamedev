extends Node

var heightmap: Image = load(ProjectSettings.get_setting("shader_globals/heightmap").value).get_image()
var curve: Curve = load(ProjectSettings.get_setting("shader_globals/mycurve").value).get_curve()
var amplitude: float = ProjectSettings.get_setting("shader_globals/amplitude").value

var size = heightmap.get_width()
#func _ready():
	#print(load(ProjectSettings.get_setting("shader_globals/mycurve").value).sample(0.5))
func get_height(x,z):
	var height = heightmap.get_pixel(fposmod(x, size), fposmod(z, size)).r
	return curve.sample(height) * amplitude
	#return curve.get_pixel(height).r * amplitude
