vec3 attr_Normal;

uniform sampler2D u_DiffuseMap;
uniform vec4      u_Color;

varying vec2      var_Tex1;


void main()
{
	gl_FragColor = vec4(attr_Normal, 1);
}
