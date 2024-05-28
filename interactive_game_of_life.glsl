#version 300 es
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

out vec4 fragColor;

uniform vec2 resolution;
uniform int pointerCount;
uniform vec3 pointers[8];
uniform sampler2D backbuffer;
uniform float time;
uniform sampler2D noise;
uniform int frame;

float get(float x, float y) {
	float val = texture(backbuffer,
		(gl_FragCoord.xy + vec2(x, y)) / resolution).b;
	val = step(0.01, val);
	return val;
}

float oneIfZero(float value) {
	return step(abs(value), 0.1);
}

float evaluate(float sum) {
	float has3 = oneIfZero(sum - 3.0);
	float has2 = oneIfZero(sum - 2.0);
	// a cell is (or becomes) alive if it has 3 neighbors
	// or if it has 2 neighbors *and* was alive already
	return has3 + has2 * get(0.0, 0.0);
}

void main() {
	vec2 pos = gl_FragCoord.xy;
	vec2 uv = pos / resolution.xy;
	float sum =
		get(-1.0, -1.0) +
		get(-1.0, 0.0) +
		get(-1.0, 1.0) +
		get(0.0, -1.0) +
		get(0.0, 1.0) +
		get(1.0, -1.0) +
		get(1.0, 0.0) +
		get(1.0, 1.0);

	float tap = min(resolution.x, resolution.y) * 0.05;
	for (int n = 0; n < pointerCount; ++n) {
		if (distance(pointers[n].xy, gl_FragCoord.xy) < tap) {
			sum = 3.0;
			break;
		}
	}

	if (pos.x < 1.0 || pos.y < 1.0 ||
			pos.x > resolution.x - 1.0 ||
			pos.y > resolution.y - 1.0) {
		float x = texture(noise, uv + time).r;
		x = step(0.4, x) * 3.0;
		sum = x;
	}


	vec3 col = vec3(uv, sin(time * 0.5)*0.2 + 0.7);
	col *= evaluate(sum);

	fragColor = vec4(col, 1.0);
}