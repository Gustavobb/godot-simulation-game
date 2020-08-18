shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 0.0);
uniform float speed = 0.02;

void fragment() {
	
	COLOR = texture(TEXTURE, UV + direction * TIME * speed);
}