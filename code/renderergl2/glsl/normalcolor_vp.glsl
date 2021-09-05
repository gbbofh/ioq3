attribute vec3 attr_Position;
attribute vec3 attr_Normal;

uniform mat4   u_ModelViewProjectionMatrix;

out vec3 v_Normal;

void main()
{
	gl_Position = u_ModelViewProjectionMatrix * vec4(attr_Position, 1.0);
	v_Normal = attr_Normal;
}
