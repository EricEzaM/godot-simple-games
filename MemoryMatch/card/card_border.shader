shader_type canvas_item;

uniform float circle_radius = 1;
uniform float border_thickness = 0;
uniform float border_smoothing_distance = 0.2;
uniform vec4 border_color : hint_color = vec4(1,0,0,1);

// Circle not used, just here for testing and practice 
vec4 circle(vec2 _uv){
	//	Get the distance to the center by getting the distance of the UV to the 
	//	point [0.5,0.5]. Divide by 0.5 so the values range from 0. to 1.
	float dist_to_center = distance(_uv, vec2(0.5))/0.5;
	
	float is_in_circle = step(circle_radius, dist_to_center);
	return vec4(vec3(is_in_circle), 1);
}

// Border not used - used as initial building block and testing for smooth border
vec4 border(vec2 _uv){
//	Returns [0,0] when the x and y point are lower than the thickness
//	Thus the colour of the point should be x * y, since we only want the 
//	point to be black when either one is within the border
	vec2 tl = step(border_thickness, _uv);
//	Repeat this process for the top right. Take vec2(1) - UV to 'reverse'
//	the direction of the same calculation that was done for top left
	vec2 br = step(border_thickness, vec2(1) - _uv);
	return vec4(1) - vec4(tl.x * tl.y * br.x * br.y);
}

vec4 border_smooth(vec2 _uv){
	vec2 tl = smoothstep(vec2(border_thickness), vec2(border_thickness + border_smoothing_distance), _uv);
	vec2 br = smoothstep(vec2(border_thickness), vec2(border_thickness + border_smoothing_distance), vec2(1) - _uv);
	
	// We don't want the border to add alpha, so keep the alpha of it zero
	return vec4(1) - vec4(vec3(tl.x * tl.y * br.x * br.y), 0);
}

void fragment(){
	vec4 tx = texture(TEXTURE, UV);
	vec4 border = border_smooth(UV);
	//	Border alpha can be changed via color property
	COLOR = mix(tx, border * border_color, border.r * border_color.a) * tx.a;
}