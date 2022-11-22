#ifndef RETROLIGHT_EDGES_PASS_DEFINED
#define RETROLIGHT_EDGES_PASS_DEFINED

#include "../ShaderLibrary/GBuffer.hlsl"

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    UNITY_DEFINE_INSTANCED_PROP(float4, _MainColor);
    UNITY_DEFINE_INSTANCED_PROP(float4,_MainTex_ST);
    UNITY_DEFINE_INSTANCED_PROP(float, _Cutoff);
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

#define InputProp(prop) UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial, prop)

struct Attributes {
    float3 positionOS : POSITION;
    float2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct V2F {
    float4 positionCS : SV_POSITION;
    float2 uv : V2F_UV
    UNITY_VERTEX_INPUT_INSTANCE_ID;
};

V2F EdgesVertex(Attributes input) {
    V2F output;
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    float3 positionWS = TransformObjectToWorld(input.positionOS);
    output.positionCS = TransformWorldToHClip(positionWS);
    float4 baseST = InputProp(_MainTex_ST);
    output.uv = input.uv * baseST.xy + baseST.zw;
    return output;
}

float2 EdgesFragment(V2F input) : SV_TARGET { //r for depth edge strength, g for normal edge strength
    UNITY_SETUP_INSTANCE_ID(input)
    float baseMap = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv).a;
    float baseAlpha = InputProp(_MainColor).a;
    float alpha = baseMap * baseAlpha;
    clip(alpha - InputProp(_Cutoff));

    #ifdef _EDGES_ENABLED
        //todo: calculate the DEI and NEI

        float dei = 0;
        float nei = 0;

        return float2(dei, nei);
    #else
        return float2(0, 0);
    #endif
}

#endif