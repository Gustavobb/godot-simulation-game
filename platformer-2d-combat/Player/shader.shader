shader_type canvas_item;

uniform bool active = false;
uniform sampler2D emission_texture;
uniform vec4 glow_color: hint_color = vec4(1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 new_color = previous_color;
	
	vec4 emission_color = texture(emission_texture, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	// glow
	if (emission_color.r > 0f) new_color = (new_color + glow_color);	
	//blink
	if (active) new_color = white_color;
	
	COLOR = new_color;
}