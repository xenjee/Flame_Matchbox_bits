#version 120
// based on: http://www.ozone3d.net/smf/index.php?topic=68.0
// original matchbox by ivar beer ivar@inferno-op.com
// modified by xenjee@gmail.com

uniform sampler2D source;
uniform float adsk_result_w, adsk_result_h;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);
uniform float contrast;
uniform bool clamp_values, comp_on_bg;

uniform float k0;
uniform float k1;
uniform float k2;
uniform float k3;
uniform float k4;
uniform float k5;
uniform float k6;
uniform float k7;
uniform float k8;

float step_w = 1.0 / resolution.x;
float step_h = 1.0 / resolution.y;


float overlay( float s, float d )
{
	return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
}

vec3 overlay( vec3 s, vec3 d )
{
	vec3 c;
	c.x = overlay(s.x,d.x);
	c.y = overlay(s.y,d.y);
	c.z = overlay(s.z,d.z);
	return c;
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec3 original = texture2D(source, uv).rgb;

	vec2 offset[9];
	float kernel[ 9 ];

	offset[ 0 ] = vec2(-step_w, -step_h);
	offset[ 1 ] = vec2(0.0, -step_h);
	offset[ 2 ] = vec2(step_w, -step_h);
	offset[ 3 ] = vec2(-step_w, 0.0);
	offset[ 4 ] = vec2(0.0, 0.0);
	offset[ 5 ] = vec2(step_w, 0.0);
	offset[ 6 ] = vec2(-step_w, step_h);
	offset[ 7 ] = vec2(0.0, step_h);
	offset[ 8 ] = vec2(step_w, step_h);
	kernel[ 0 ] = k0;
	kernel[ 1 ] = k1;
	kernel[ 2 ] = k2;
	kernel[ 3 ] = k3;
	kernel[ 4 ] = k4;
	kernel[ 5 ] = k5;
	kernel[ 6 ] = k6;
	kernel[ 7 ] = k7;
	kernel[ 8 ] = k8;


   int i = 0;
   vec3 col = vec3(0.0);

   for( int i=0; i<9; i++ )
   {
    vec4 tmp = texture2D(source, uv + offset[i]);
    col += tmp.rgb * kernel[i];
   }
   col = col * contrast + 0.5;
   
   if ( clamp_values )
	   col = clamp(col, 0.0, 1.0);
   
   if ( comp_on_bg )
	   col =  overlay(col, original);
   
   gl_FragColor = vec4(col, 1.0);
}