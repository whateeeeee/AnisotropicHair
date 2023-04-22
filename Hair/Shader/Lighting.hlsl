#pragma once

CusLightingData CalculateLightingData(VertexOutput vertexOutput, float3 sampledNormal, float3 direction)
{
    CusLightingData lightingData;

	lightingData.worldPos = float3(vertexOutput.worldNormalDir.w, vertexOutput.worldTangentDir.w, vertexOutput.worldBitangentDir.w);
    //lightingData.worldNormal = vertexOutput.worldNormalDir;
	lightingData.worldLightDir = normalize(direction);
	lightingData.worldViewDir = normalize(_WorldSpaceCameraPos.xyz - lightingData.worldPos);

	float3 TtoW1 = float3(vertexOutput.worldTangentDir.x,vertexOutput.worldBitangentDir.x,vertexOutput.worldNormalDir.x);
    float3 TtoW2 = float3(vertexOutput.worldTangentDir.y,vertexOutput.worldBitangentDir.y,vertexOutput.worldNormalDir.y);
    float3 TtoW3 = float3(vertexOutput.worldTangentDir.z,vertexOutput.worldBitangentDir.z,vertexOutput.worldNormalDir.z);

	float3x3 TtoW_Matrix = float3x3(TtoW1, TtoW2, TtoW3);

	lightingData.worldNormal = mul(TtoW_Matrix,sampledNormal);

	float3 H = normalize(lightingData.worldLightDir + lightingData.worldViewDir).xyz;
    lightingData.H = H;

	lightingData.NoL = saturate(dot(lightingData.worldLightDir, lightingData.worldNormal));
	lightingData.NoV = saturate(dot(lightingData.worldNormal, lightingData.worldViewDir));
	lightingData.NoH = saturate(dot(lightingData.worldNormal, H));
	lightingData.LoH = saturate(dot(lightingData.worldLightDir, H));
    lightingData.RoV = saturate(dot(lightingData.worldViewDir, reflect(lightingData.worldLightDir, lightingData.worldNormal)));
    
    lightingData.R = normalize(reflect(-lightingData.worldViewDir, lightingData.worldNormal)).xyz;

	return lightingData;
}

float DiffuseTerm(CusLightingData lightingData)
{
    float diffuse = max(0, 0.75 * lightingData.NoL + 0.25);
    return diffuse;
}

float3 ShiftTangent(VertexOutput vertexOutput, float shift)
{
    return normalize(vertexOutput.worldBitangentDir + vertexOutput.worldNormalDir * shift).xyz;
}

float AnisotropySpecular(VertexOutput vertexOutput, CusLightingData lightingData, float width, float strength, float3 shiftedTangent)
{

    float3 H = (lightingData.worldLightDir + lightingData.worldViewDir) * rsqrt(max(2.0 * dot(lightingData.worldLightDir, lightingData.worldViewDir) + 2.0, FLT_EPS));

    float dotTH = dot(shiftedTangent, H);

    float sinTH = max(0.01, sqrt(1 - pow(dotTH, 2)));
    float dirAtten = smoothstep(-1, 0, dotTH);
    return dirAtten * pow(sinTH, width * 10.0) * strength;
}
