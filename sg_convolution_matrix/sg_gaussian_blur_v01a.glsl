
//[Pixel_Shader]


uniform float k0;
uniform float k1;
uniform float k2;
uniform float k3;
uniform float k4;
uniform float k5;
uniform float k6;
uniform float k7;
uniform float k8;

uniform float gain;



#define KERNEL_SIZE 9

// Gaussian kernel
// 1 2 1
// 2 4 2
// 1 2 1	
float kernel[KERNEL_SIZE];

uniform sampler2D source;
uniform float adsk_result_w, adsk_result_h;
vec2 res = vec2(adsk_result_w, adsk_result_h);

float step_w = 1.0/res.x;
float step_h = 1.0/res.y;

vec2 offset[KERNEL_SIZE];
						 
void main(void)
{
   int i = 0;
   vec4 sum = vec4(0.0);
   
   offset[0] = vec2(-step_w, -step_h);
   offset[1] = vec2(0.0, -step_h);
   offset[2] = vec2(step_w, -step_h);
   
   offset[3] = vec2(-step_w, 0.0);
   offset[4] = vec2(0.0, 0.0);
   offset[5] = vec2(step_w, 0.0);
   
   offset[6] = vec2(-step_w, step_h);
   offset[7] = vec2(0.0, step_h);
   offset[8] = vec2(step_w, step_h);
   
   kernel[0] = k0/16.0; 	kernel[1] = k1/16.0;	kernel[2] = k2/16.0;
   kernel[3] = k3/16.0;		kernel[4] = k4/16.0;	kernel[5] = k5/16.0;
   kernel[6] = k6/16.0;   	kernel[7] = k7/16.0;	kernel[8] = k8/16.0;
   
   
   
	   for( i=0; i<KERNEL_SIZE; i++ )
	   {
			vec4 tmp = texture2D(source, gl_TexCoord[0].st + offset[i]);
			sum += tmp * kernel[i];
	   }
  
   
   gl_FragColor = sum * gain;
}