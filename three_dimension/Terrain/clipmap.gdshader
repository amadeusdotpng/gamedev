shader_type spatial;

global uniform sampler2D heightmap;
global uniform sampler2D normalmap;
global uniform sampler2D mycurve;
global uniform float amplitude;

varying vec2 texture_position;
varying float height;

void vertex() {
	vec3 world_vertex = VERTEX + MODEL_MATRIX[3].xyz;
	texture_position = (world_vertex.xz + 0.5) / float(textureSize(heightmap, 0).x);
	height = texture(mycurve, texture(heightmap, texture_position).xz).r;
	VERTEX.y = height * amplitude;
	// VERTEX.y = texture(heightmap, texture_position).r * texture(mycurve, texture(heightmap, texture_position).xz).r * amplitude;
	//VERTEX.y = texture(heightmap, texture_position).r * amplitude * 4.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	if(height < 0.089) {
		ALBEDO = vec3(0,0,255)/255.0;
	} else if(height < 0.15) {
		ALBEDO = vec3(0,200,0)/255.0;
	} else if(height < 0.25){
		ALBEDO = vec3(127,127,127)/255.0;
	} else {
		ALBEDO = vec3(200,200,200)/255.0;
	}
	NORMAL_MAP = texture(normalmap, texture_position).rgb;
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
