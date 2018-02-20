texture gTexture;

float4 ClearMe() : COLOR0
{
    return 0;
}

technique ClearTexture
{
    pass p0
    {
        AlphaBlendEnable = TRUE;
        Texture[0] = gTexture;
    }
}

technique fallback
{
    pass P0
    {
    }
}
