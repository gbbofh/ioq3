attribute vec3 attr_Position;
attribute vec3 attr_Normal;
attribute vec4 attr_TexCoord0;

uniform mat4   u_ModelMatrix;

varying vec2   var_Tex1;

out vec3 v_Normal;

void main()
{
	gl_Position = u_ModelMatrix * vec4(attr_Position, 1.0);
	v_Normal = vec3(u_ModelMatrix * vec4(attr_Normal, 1.0));
	var_Tex1 = attr_TexCoord0.st;
}
