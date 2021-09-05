in vec3 v_Normal;

void main()
{
	gl_FragColor = vec4(v_Normal, 1);
}
