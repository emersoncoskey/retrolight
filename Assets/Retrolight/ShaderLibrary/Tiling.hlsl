#ifndef RETROLIGHT_TILING_INCLUDED
#define RETROLIGHT_TILING_INCLUDED

#include "../ShaderLibrary/Common.hlsl"

#define TILE_DIMENSION 8 // tiles are 8x8
#define SCREEN_TILES int2(Resolution.xy / TILE_DIMENSION)

//todo: revisit to ensure float/int stuff is converted correctly

//xy is index of tile
//zw is pixel offset from tile origin (top right)
float2 TileToUV(int4 tile) {
    return (tile.xy * TILE_DIMENSION + tile.zw) * Resolution.zw;
}

int4 UVToTile(float2 uv) {
    int2 pixelPos = uv * Resolution.xy;
    int4 result;
    result.xy = pixelPos / TILE_DIMENSION;
    result.zw = pixelPos % TILE_DIMENSION;
    return result;
}

float2 PixelToUV(float2 pix) {
    return pix * Resolution.zw;
}

#endif