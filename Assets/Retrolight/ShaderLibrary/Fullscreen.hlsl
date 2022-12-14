#ifndef RETROLIGHT_FULLSCREEN_INCLUDED
#define RETROLIGHT_FULLSCREEN_INCLUDED

#if !defined(FULLSCREEN_ST)
#define FULLSCREEN_ST float4(1, 1, 0, 0)
#endif

#include "Common.hlsl"
#include "Viewport.hlsl"

struct V2F {
    float4 positionCS : SV_Position;
    float2 uv : V2F_UV;
};

V2F FullscreenVertex(uint vertexId : VERTEXID_SEMANTIC) {
    V2F output;
    output.positionCS = GetFullScreenTriangleVertexPosition(vertexId);
    output.uv = GetFullScreenTriangleTexCoord(vertexId) * ViewportScale * FULLSCREEN_ST.xy + FULLSCREEN_ST.zw;
    #if UNITY_UV_STARTS_AT_TOP
    if (_ProjectionParams.x >= 0)
        output.uv.y = 1 - output.uv.y;
    #endif
    return output;
}

#endif
