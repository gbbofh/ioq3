attribute vec3 attr_Position;
attribute vec3 attr_Normal;
attribute vec4 attr_TexCoord0;

uniform mat4   u_ModelViewProjectionMatrix;

varying vec2   var_Tex1;

out vec3 v_Normal;

void main()
{
	gl_Position = u_ModelViewProjectionMatrix * vec4(attr_Position, 1.0);
	v_Normal = attr_Normal;
	var_Tex1 = attr_TexCoord0.st;
}
