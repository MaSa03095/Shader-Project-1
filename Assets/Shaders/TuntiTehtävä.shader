Shader "Custom/TuntiTehtävä"
{
    Properties
    {
_MainTex("Main Texture",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        
        Pass
        {
HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);         

CBUFFER_START(UnityPerMaterial);
float4 _Color;
float _Shininess;
float4 _MainTex_ST;
CBUFFER_END

struct Attributes
{
    float4 positionOS : POSITION;
    float2 uv : TEXCOORD0;
};
struct Varyings
{
    float4 positionHCS : SV_POSITION;
    float2 uv : TEXTCOORD2;
};
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
Varyings vert(Attributes input)
{
    Varyings output;
    output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);
    output.uv = input.uv * _MainTex_ST.xy + _MainTex_ST.zw + _Time.y * float2(0.5, 1);
    return output;
}

float4 frag(Varyings input) : SV_TargeT
{
return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
}
ENDHLSL

        }
    }
}