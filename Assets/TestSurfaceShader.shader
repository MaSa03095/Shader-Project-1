Shader"Custom/TestSurfaceShader"
{

    Properties
{
        [
    KeywordEnum(Red, Green, Blue, Black)]
    _ColorKeyword("Color", Float) = 0

}
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        Pass {
Name"Forward Lit"
            Tags
{"LightMode" = "UniversalForward"
}

            HLSLPROGRAM

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            #pragma vertex Vertex
            #pragma fragment Fragment

            #pragma shader_feature_local_fragment _COLORKEYWORD_RED _COLORKEYWORD_GREEN _COLORKEYWORD_BLUE _COLORKEYWORD_BLACK

float4 Vertex(float3 positionOS : POSITION) : SV_POSITION
{
    return TransformObjectToHClip(positionOS);
}

float4 Fragment() : SV_TARGET
{
                
    float4 col = 1;
                
#if _COLORKEYWORD_RED
                col = float4(1, 0, 0, 1);
#elif _COLORKEYWORD_GREEN
                col = float4(0, 1, 0, 1);
#elif _COLORKEYWORD_BLUE
                col = float4(0, 0, 1, 1);
#elif _COLORKEYWORD_BLACK
                col = float4(0, 0, 0, 1);
#endif

    return col;
}

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

// This is the input struct for the vertex stage.
struct Attributes
{
    float3 positionOS : POSITION; // The object space position of the vertex
};

// This is the output struct for the vertex stage.
struct Varyings
{
    float4 positionHCS : SV_POSITION; // (homogenous) Clip space position, used for interpolation
};

// The vertex stage function
Varyings Vertex(const Attributes input)
{
    Varyings output; // The output struct
    // Here we transform the coordinates from object to clip space
    // with ProjectionMatrix * ViewMatrix * ModelMatrix * PositionVector
    output.positionHCS = TransformObjectToHClip(input.positionOS);
    return output;
}

// Semantics can be applied directly to functions and parameters
// The previous function could be rewritten as:
// float4 Vertex(const float3 positionOS : POSITION) : SV_POSITION {
//     return TransformObjectToHClip(positionOS);
// }
// This is not done, however because usually you want more than one input or output
// In those cases, it's easier to put them into a struct

// The fragment stage function
half4 Fragment(const Varyings input) : SV_TARGET
{ // Color semantic
    return half4(1, 1, 1, 1);
}

            ENDHLSL
        }
    }
}
