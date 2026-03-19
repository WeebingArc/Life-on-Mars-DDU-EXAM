// Her defineres shaderen er i en 3D projekt og den skal 
// ignorerer alle lys effekter der er i projekten.
shader_type spatial;
render_mode unshaded, depth_draw_never;

// Dette siger at der sker en blanding outlineen med det sidste billede
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Her bliver der sagt at forskellen i normal textureen
// som skal der laves en sort linje, som laver outlineen.
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

// Her er forskellige parameter der ændre hvordan selve effekten ser ud, 
// som hvor tyk linjen er og hvilke farve det er
uniform float edge_threshold = 0.1;
uniform vec3 line_color : source_color = vec3(0, 0, 0);

// Sobel-filtre er brugt her for at finde hjørnerne i det 
// renderede billede i projektet, både på y-aksen og x-aksen.

// En Sobel-filter er noget der sætter en billede i sort og hvid, men er mere intenst
// sort omkringer hjørner
const mat3 sobel_y = mat3(
	vec3( 1.0,  0.0, -1.0),
	vec3( 2.0,  0.0, -2.0),
	vec3( 1.0,  0.0, -1.0)
);

const mat3 sobel_x = mat3(
	vec3( 1.0,  2.0,  1.0),
	vec3( 0.0,  0.0,  0.0),
	vec3(-1.0, -2.0, -1.0)
);

// Her bliver texture normels omskrevet til en ordenlig normel
// Pga af denne omskrevelse er fordi texture normals er i 0..1
// men rigtige normals er -1..1
vec3 normalize_normal(vec3 normal){
	return normalize(normal * 2.0 - 1.0);
}

// Her sættes Quad Mesh'en til at ikke kun være på en objekt,
// men så er på hele skærmen
void vertex(){
	// Fullscreen quad
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

// Her bruges alle de forskellige functioner der læser farverne på skærmen,
// læse normalsene rundt omkring forskellige pixels på skærmen,
// måle forskellen på normals,
// anvende sobel-filteren,
// bestemme hvis en pixel er en edge
// og til sidst farve outlinen over objektet 
void fragment() {

	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);

	vec2 offset = 1.0 / VIEWPORT_SIZE;

	vec3 normal = normalize_normal(texture(NORMAL_TEXTURE, uv).rgb);

	vec3 n  = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2(0.0, -offset.y)).rgb);
	vec3 s  = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2(0.0,  offset.y)).rgb);
	vec3 e  = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2( offset.x, 0.0)).rgb);
	vec3 w  = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2(-offset.x, 0.0)).rgb);
	vec3 nw = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2(-offset.x, -offset.y)).rgb);
	vec3 ne = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2( offset.x, -offset.y)).rgb);
	vec3 sw = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2(-offset.x,  offset.y)).rgb);
	vec3 se = normalize_normal(texture(NORMAL_TEXTURE, uv + vec2( offset.x,  offset.y)).rgb);

	mat3 surrounding_pixels = mat3(
		vec3(length(nw - normal), length(n - normal), length(ne - normal)),
		vec3(length(w  - normal), 0.0,               length(e  - normal)),
		vec3(length(sw - normal), length(s - normal), length(se - normal))
	);

	float edge_x =
		dot(sobel_x[0], surrounding_pixels[0]) +
		dot(sobel_x[1], surrounding_pixels[1]) +
		dot(sobel_x[2], surrounding_pixels[2]);

	float edge_y =
		dot(sobel_y[0], surrounding_pixels[0]) +
		dot(sobel_y[1], surrounding_pixels[1]) +
		dot(sobel_y[2], surrounding_pixels[2]);

	float edge = length(vec2(edge_x, edge_y));

	float edge_mask = step(edge_threshold, edge);

	vec3 final_color = mix(screen_color.rgb, line_color, edge_mask);

// Dette sætter farverne på skærmen så effekten kan virke
	ALBEDO = final_color;
}