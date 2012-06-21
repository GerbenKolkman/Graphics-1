//------------------------------------------- Defines -------------------------------------------

#define Pi 3.14159265
#define MAX_LIGHTS 3

//------------------------------------- Top Level Variables -------------------------------------
float4x4 World, View, Projection, InvTransWorld;
float4 DiffuseColor;
float4 LightColors[MAX_LIGHTS];
float3 LightPositions[MAX_LIGHTS];

// TODO: add effect parameters here.

struct VertexShaderInput
{
	float4 Position3D : POSITION0;
	float3 normal : NORMAL0;
	float4 color : COLOR0;
};

struct VertexShaderOutput
{
	float4 Position2D : POSITION0;
	float3 normal : TEXCOORD0;
	float4 Position3D : TEXCOORD1;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	// Allocate an empty output struct
	VertexShaderOutput output = (VertexShaderOutput)0;

	// Do the matrix multiplications for perspective projection and the world transform
	float4 worldPosition = mul(input.Position3D, World);
    float4 viewPosition  = mul(worldPosition, View);
	output.Position2D    = mul(viewPosition, Projection);

	//pass variables
	output.Position3D    = input.Position3D;
	output.normal        = input.normal;

	return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float3 N = normalize(mul(input.normal, InvTransWorld));
	float4 diffuse = float4(0.0f,0.0f,0.0f,0.0f);
	for (int i = 0; i < MAX_LIGHTS; i++)
	{
		float3 L = normalize(LightPositions[i] - input.Position3D);
		diffuse += max(0,dot(N,L))*LightColors[i]*DiffuseColor;
	}
    // TODO: add your pixel shader code here.
    return diffuse;
}

technique MultiLight
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}