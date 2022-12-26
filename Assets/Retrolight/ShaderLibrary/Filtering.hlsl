#ifndef RETROLIGHT_DITHERING_INCLUDED
#define RETROLIGHT_DITHERING_INCLUDED

//bayer matrix values copied from Acerola on YT
static const int bayer2[2 * 2] = {
    0, 2,
    3, 1,
};

static const int bayer4[4 * 4] = {
    0,  8,  2,  10,
    12, 4,  14, 6,
    3,  11, 1,  9,
    15, 7,  13, 5
};

static const int bayer8[8 * 8] = {
    0,  32, 8,  40, 2,  34, 10, 42,
    48, 16, 56, 24, 50, 18, 58, 26,
    12, 44, 4,  36, 14, 46, 6,  38,
    60, 28, 52, 20, 62, 30, 54, 22,
    3,  35, 11, 43, 1,  33, 9,  41,
    51, 19, 59, 27, 49, 17, 57, 25,
    15, 47, 7,  39, 13, 45, 5,  37,
    63, 31, 55, 23, 61, 29, 53, 21
};

float3 Dither4(float3 value, float spread, uint2 pos) {
    uint2 matrixPos = pos % 4;
    uint matrixIndex = matrixPos.y * 4 + matrixPos.x;
    const int matrixValue = bayer4[matrixIndex];
    const float normMatrixValue = matrixValue / 16.0f - 0.5f;
    return value + normMatrixValue * spread;
}

float3 Dither8(float3 value, float spread, uint2 pos) {
    uint2 matrixPos = pos % 8;
    uint matrixIndex = matrixPos.y * 8 + matrixPos.x;
    const int matrixValue = bayer8[matrixIndex];
    const float normMatrixValue = matrixValue / 64.0f - 0.5f;
    return value + normMatrixValue * spread;
}



float3 Quantize(float3 value, int steps) {
    return floor(value * (steps - 1) + 0.5) / (steps - 1);
}

float DitherQuantize8(float value, float spread, int steps, uint2 pos) {
    float quantized = Quantize(value, steps);
    float diff = abs(value - quantized) * steps;
    return Quantize(Dither8(value, (1 - diff) * spread, pos), steps);
}

#endif