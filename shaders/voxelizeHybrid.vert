//*****************************************************************************
//voxelizeHybrid.vert**********************************************************
//*****************************************************************************

#version 420

// IN (from OpenGL)
layout(location = 0) in vec3 in_vertexPos;
layout(location = 1) in vec3 in_vertexNormal;
layout(location = 2) in vec2 in_texCoord;
//Animation stuff
layout(location = 3) in  uint boneIDs0;
layout(location = 4) in float boneWeights0;

const int MAX_BONES = 100;

uniform mat4 bones[MAX_BONES];
uniform uint numBones;

uniform mat4 unitToVoxel;	//transforms and scales from (-0.5 to 0.5) to (0 to voxelDim)

// IN (uniform)
uniform ivec3 volumeDim;

out block
{
	vec3 vertexPos;
	vec3 vertexNormal;
	vec2 texCoord;
	int  vertexID;
} Out;

out gl_PerVertex
{
	vec4 gl_Position;
};

uniform mat4 modelMatrix;

void main()
{
	vec4 vertexPos;
	if(numBones > 0)
	{
		mat4 boneMatrix = bones[boneIDs0] * boneWeights0;
		vec4 bonePos    = boneMatrix * vec4(in_vertexPos, 1);
		vertexPos = modelMatrix * bonePos;
	}
	else
	{
		vertexPos = modelMatrix * vec4(in_vertexPos, 1);
	}

	vertexPos *= unitToVoxel;
	Out.vertexPos    = vertexPos.xyz;
	Out.vertexNormal = in_vertexNormal;
	Out.texCoord     = in_texCoord;
	Out.vertexID     = gl_VertexID;
	gl_Position      = vertexPos;

}

