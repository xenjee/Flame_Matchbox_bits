// Mid blur vertical pass and split/scale/combine
// lewis@lewissaunders.com  // modified by xenjee@gmail.com ** v01b

uniform sampler2D adsk_results_pass1, adsk_results_pass3, adsk_results_pass4;
uniform float adsk_result_w, adsk_result_h;
uniform float midfreqlimit;
uniform bool outputlow, outputmid, outputhigh;
uniform float gainlow, gainmid, gainhigh;
const float pi = 3.141592653589793238462643383279502884197969;

void main() {
	vec2 xy = gl_FragCoord.xy;
	vec2 px = vec2(1.0) / vec2(adsk_result_w, adsk_result_h);

	

	float sigma = midfreqlimit;
	int support = int(sigma * 3.0);

	// Incremental coefficient calculation setup as per GPU Gems 3
	vec3 g;
	g.x = 1.0 / (sqrt(2.0 * pi) * sigma);
	g.y = exp(-0.5 / (sigma * sigma));
	g.z = g.y * g.y;

	if(sigma == 0.0) {
		g.x = 1.0;
	}

	// Centre sample
	vec4 a = g.x * texture2D(adsk_results_pass4, xy * px);
	float energy = g.x;
	g.xy *= g.yz;

	// The rest
	for(int i = 1; i <= support; i++) {
		a += g.x * texture2D(adsk_results_pass4, (xy - vec2(0.0, float(i))) * px);
		a += g.x * texture2D(adsk_results_pass4, (xy + vec2(0.0, float(i))) * px);
		energy += 2.0 * g.x;
		g.xy *= g.yz;
	}
	a /= energy;

	vec4 front = texture2D(adsk_results_pass1, xy * px);
	vec4 low = texture2D(adsk_results_pass3, xy * px);
	vec4 mid = a - low;
	vec4 high = front - a;

	low *= gainlow;
	mid *= gainmid;
	high *= gainhigh;

	vec4 o = vec4(0.5);


	if(outputlow) o = low;
	if(outputmid) o += mid;
	if(outputhigh) o += high;

	gl_FragColor = o;
}
