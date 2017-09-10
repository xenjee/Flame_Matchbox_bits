uniform float adsk_result_w, adsk_result_h, adsk_result_frameratio;
uniform sampler2D adsk_results_pass5;
uniform float rotation;
uniform float rotation2;

	float rotationback = - (rotation + rotation2);

bool isInTex( const vec2 normcoords )
{
   return normcoords.x >= 0.0 && normcoords.x <= 1.0 &&
          normcoords.y >= 0.0 && normcoords.y <= 1.0;
}


void main()
{
	
   vec2 normcoords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
 
   mat2 rotationMatrice = mat2( cos(-rotationback), -sin(-rotationback), sin(-rotationback), cos(-rotationback) );
		  
   float frameRatio = adsk_result_frameratio;   			  

   normcoords -= vec2(0.5);

   normcoords.x *= frameRatio;
  
   normcoords *= rotationMatrice;

   normcoords.x /= frameRatio;

   normcoords += vec2(0.5);
 
   if ( isInTex( normcoords ) )
   {
   gl_FragColor = texture2D(adsk_results_pass5, normcoords).rgba; 
   }

  
}
