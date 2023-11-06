Shader "Custom/RockShader"
{
    Properties
    {
        // This is an example of a shader that supports most of Unity's lighting features
        // using the Forward renderer.
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" { }
        [NoScaleOffset] [Normal] _NormalMap("Normal Map", 2D) = "bump" { }
        [NoScaleOffset] _RoughnessMap("Roughness Map", 2D) = "white" { }
        [NoScaleOffset] _OcclusionMap("Ambient Occlusion Map", 2D) = "white" { }
        [NoScaleOffset] _MetallicMap("Metallic Map", 2D) = "black" { }
        [NoScaleOffset] _ParallaxMap ("Parallax Map", 2D) = "black" { }
	_ParallaxStrength ("Parallax Strength", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags {"RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" "Queue"="Geometry"}
HLSLINCLUDE

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ParallaxMapping.hlsl"

struct Attributes
{
    float3 positionOS : POSITION;
    float2 uv0 : TEXCOORD0;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float3 normalOS : NORMAL;
    float4 tangentOS : TANGENT;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
struct Varyings
{
    float4 positionHCS : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 positionWS : TEXCOORD1;
    float3 normalWS : TEXCOORD2;
    float4 tangentWS : TEXCOORD3;
    half fogFactor : TEXCOORD4;
    half3 viewDirTS : TEXCOORD5;
    DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, sh, 6);
    #if defined(DYNAMICLIGHTMAP_ON)
    float2  dynamicLightmapUV : TEXCOORD7;
    #endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

ENDHLSL

        Pass {
Name"ForwardLit"
            Tags
{"LightMode" = "UniversalForward"
}

Cull Back

Blend One
Zero
            ZTest
LEqual
            ZWrite
On

            HLSLPROGRAM

            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5
            
            #pragma vertex Vertex
            #pragma fragment Fragment

            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS

            // Unity defined keywords
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog

            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer

            #include "SurfaceShaderExample6Program.hlsl"

            ENDHLSL
        }
    }
}