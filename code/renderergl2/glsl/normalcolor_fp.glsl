in vec3 v_Normal;

uniform sampler2D u_DiffuseMap;

void main()
{
	gl_FragColor = vec4(attr_Normal, 1);
}
