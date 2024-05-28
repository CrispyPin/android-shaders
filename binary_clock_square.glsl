#version 300 es
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec4 date;

out vec3 col;

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.x;
	uv.x = 1.0 - uv.x;
	uv.y -= (resolution.y / resolution.x) * 0.5 - 0.5;

	int x = int(uv.x * 4.0);
	int y = int(uv.y * 4.0 + 1.0) - 1;
	col = vec3(0.1, 0.1, 0.1);
	if (y < 4 && y >= 0) {
		vec2 c = vec2(x, y) / 4.0 + 0.125;
		float r = length(c - uv);
		float seconds = date.w;
		int time = int(seconds / (3600.0 * 24.0) * 65536.0);
		int bit = y * 4 + x;
		bool state = ((time >> bit) & 1) == 1;
		if (r < 0.05 && (r > 0.04 || state))
			col = vec3(0.1, 1, 1);
	}
}
