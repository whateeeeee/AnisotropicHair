Shader "URP/Hair"
{
	Properties
	{
		[Header(Texture)]
		_MainColor("Main Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_AnisotropyTexture("Anisotropy Map", 2D) = "white" {}

		_FlowMap ("Flow Map",2D) = "white" {}

		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_DiffuseColor2 ("Diffuse Color2",Color) = (1,1,1,1)

		_NormalIntensity ("Normal Intensity",Range(0,2)) = 1
		_Anisotropy("Anisotropy", Range(0.0, 1.0)) = 0.5

		[Header(First Specular Settings)]
		_FirstSpecularColor("First Specular Color", Color) = (1,1,1,1)
		_FirstWidth("FirstWidth", Range(0, 40)) = 2
		_FirstStrength("FirstStrength", Range(0.0, 8.0)) = 4
		_FirstOffset("First Offset", Range(-2,2)) = -0.5

		[Header(Second Specular Settings)]
		_SecondSpecularColor("Second Specular Color", Color) = (1,1,1,1)
		_SecondWidth("Second Width", Range(0.0, 300.0)) = 2
		_SecondStrength("Second Strength", Range(0.0, 8.0)) = 1.0
		_SecondOffset("_SecondOffset", Range(-2, 2)) = 0.0

		[Header(Alpha Settings)]
		_ClipValue("Clip Value", Range(0.0, 1.0)) = 0.2

		[Toggle(_AdditionalLights)] _AdditionalLights("_AdditionalLights", float) = 1
		[Toggle(_EnviromentLighting)]_EnviromentLighting("_EnviromentLighting", float) = 1
	}

	SubShader
	{
		Pass
		{
			Tags { "RenderPipeline" = "UniversalPipeline" "LightMode" = "UniversalForward" "IgnoreProjector"="True" "Queue" = "AlphaTest" }
			Cull back			
			HLSLPROGRAM

			#pragma vertex Vertex
			#pragma fragment Frag
			#pragma shader_feature _AdditionalLights
			#pragma shader_feature _EnviromentLighting

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "HairBase.hlsl"

			ENDHLSL
		}

		Pass
		{
			Tags { "RenderPipeline" = "UniversalPipeline"  "IgnoreProjector"="True" "Queue" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha 
			Cull off
			ZWrite Off
 
			HLSLPROGRAM

			#pragma vertex Vertex
			#pragma fragment Frag2
			#pragma shader_feature _AdditionalLights
			#pragma shader_feature _EnviromentLighting

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "HairBase.hlsl"

			ENDHLSL
		}

	}
}