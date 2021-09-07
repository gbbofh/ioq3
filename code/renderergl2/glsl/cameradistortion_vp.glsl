attribute vec4 attr_Position;
attribute vec4 attr_TexCoord0;

varying vec2   var_ScreenTex;

void main()
{
	gl_Position = attr_Position;
	var_ScreenTex = attr_TexCoord0.xy;
}
