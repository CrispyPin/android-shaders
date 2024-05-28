#version 300 es
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec3 daytime;

out vec3 col;

void row(float h, float bits, int val) {
	vec2 uv = gl_FragCoord.xy / resolution.x;
	uv.x = 1.0 - uv.x;
	int bit = int((uv.x) * bits);
	vec2 c = vec2(float(bit) / bits + 0.5/bits, h);
	float r = length(c - uv);
	if (r < 0.05) {
		int b = (val >> bit) & 1;
		if (r > 0.04 || b == 1)
			col = vec3(0.1, 1, 1);
	}
}

void main(void) {
	col = vec3(0.1, 0.1, 0.1);

	int hour = int(daytime.x);
	int minute = int(daytime.y);
	int second = int(daytime.z);

	row(1.2, 5.0, hour);
	row(1.0, 6.0, minute);
	row(0.8, 6.0, second);
}