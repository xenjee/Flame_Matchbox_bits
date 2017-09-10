uniform float adsk_result_w, adsk_result_h, adsk_result_frameratio;
uniform sampler2D adsk_results_pass1, adsk_results_pass2, adsk_results_pass3;
uniform float rotation2;


// This test is to know if we are inside the texture. If you want the texture to repeat, remove the following and the later if condition
bool isInTex( const vec2 normcoords )
{
   return normcoords.x >= 0.0 && normcoords.x <= 1.0 &&
          normcoords.y >= 0.0 && normcoords.y <= 1.0;
}


void main()
{
   vec2 normcoords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
 
   mat2 rotationMatrice = mat2( cos(-rotation2), -sin(-rotation2), sin(-rotation2), cos(-rotation2) );
		  
   float frameRatio = adsk_result_frameratio;   			  

   normcoords -= vec2(0.5);

   normcoords.x *= frameRatio;
  
   normcoords *= rotationMatrice;

   normcoords.x /= frameRatio;

   normcoords += vec2(0.5);
 
   if ( isInTex( normcoords ) )
   {
   gl_FragColor = texture2D(adsk_results_pass3, normcoords).rgba; 
   }

  
}
