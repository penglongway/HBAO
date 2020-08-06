#include "UnityCG.cginc"
#define E 2.71828
float4 fragBlur(v2f i) : SV_TARGET
{
    float4 col = 0;
    #if GUASSBLUR
    float sum = 0;
    #else
    float sum = _BlurSamples;
    #endif
    // float offset = (1.0 + 1) / _BlurSamples * _BlurRadiusPixel;
    // float2 uv = i.uv + float2(0, offset) * _TexelSize.xy;

    // return tex2D(_HbaoTex, uv);
    for (int index = 0; index < _BlurSamples; ++index)
    {
        float offset = (index + 1.0) / _BlurSamples * _BlurRadiusPixel;
        float2 uv = i.uv + float2(0, offset) * _TexelSize.xy;
        #if GUASSBLUR
            float sSquard = _BlurRadiusPixel * _BlurRadiusPixel;
            float offSquard = offset * offset;
            float guass = (1 / sqrt(2 * UNITY_PI * sSquard)) * pow(E, -offSquard / (2 * sSquard));
            col += tex2D(_HbaoTex, uv) * guass;
            sum += guass;
        #else
            col += tex2D(_HbaoTex, uv);
        #endif
    }
    col /= sum;
    return col;
}