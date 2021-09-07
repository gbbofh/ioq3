uniform sampler2D u_ScreenImageMap;

varying vec2   var_ScreenTex;

void main()
{
	gl_FragColor = texture(u_ScreenImageMap, var_ScreenTex);
}
