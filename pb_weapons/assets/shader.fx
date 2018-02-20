// Effect applies normalmapped lighting to a 2D sprite.

float LightDirectionX = 0;
float LightDirectionY = 0.5;
float LightDirectionZ = 1;
float3 LightColor = 1.0;
float3 AmbientColor = 0.35;

texture MainTexture;
texture NormalTexture;

sampler TextureSampler : register(s0)
{
    Texture = (MainTexture);
};
sampler NormalSampler : register(s1)
{
    Texture = (NormalTexture);
};

float4 main(float4 color : COLOR0, float2 texCoord : TEXCOORD0) : COLOR0
{
    //Look up the texture value
    float4 tex = tex2D(TextureSampler, texCoord);

    //Look up the normalmap value
    float3 normal = 2 * tex2D(NormalSampler, texCoord) - 1.0;

    float3 LightDirection = float3(LightDirectionX, LightDirectionY, LightDirectionZ);

    // Compute lighting.
    float lightAmount = max(dot(normal, LightDirection), 0);
    color.rgb *= AmbientColor + lightAmount * LightColor;

    return color * tex;//float4(lightAmount, lightAmount, lightAmount, 1);
}

technique Normalmap
{
    pass P0
    {
        PixelShader = compile ps_2_0 main();
    }
}
