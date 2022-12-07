﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CG/BlinnPhong"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (0.14, 0.43, 0.84, 1)
        _SpecularColor ("Specular Color", Color) = (0.7, 0.7, 0.7, 1)
        _AmbientColor ("Ambient Color", Color) = (0.05, 0.13, 0.25, 1)
        _Shininess ("Shininess", Range(0.1, 50)) = 10
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                // Declare used properties
                uniform fixed4 _DiffuseColor;
                uniform fixed4 _SpecularColor;
                uniform fixed4 _AmbientColor;
                uniform float _Shininess;

                struct appdata
                { 
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float3 normal : TEXCOORD0;
                    float4 worldPos : TEXCOORD1;
                };

                // Calculates diffuse lighting of secondary point lights (part 3)
                fixed4 pointLights(v2f input)
                {
                    fixed3 finalColor = fixed3(0, 0, 0);
                    for (int i=0; i<4; i++)
                    {
                        float3 lightPos = float4(unity_4LightPosX0[i], unity_4LightPosY0[i], unity_4LightPosZ0[i], 1.0);
                        float3 l = normalize(lightPos - input.worldPos).xyz;
                        float3 n = normalize(input.normal);
                        float lightPower = 1 / (1 + unity_4LightAtten0[i] * distance(input.worldPos.xyz, lightPos));
                        finalColor += max(dot(l, n) , 0) * _DiffuseColor.rgb * unity_LightColor[i].rgb * lightPower;
                        
                    }
                    return float4(finalColor, 1.0);
                    
                }


                v2f vert (appdata input)
                {
                    v2f output;
                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.normal =  normalize(mul(unity_ObjectToWorld, input.normal));
                    output.worldPos = mul(unity_ObjectToWorld, input.vertex);
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    float3 v = normalize(_WorldSpaceCameraPos - input.worldPos.xyz);
                    float3 l = normalize(_WorldSpaceLightPos0);
                    float3 n = normalize(input.normal);
                    fixed3 colorA = _AmbientColor * _LightColor0;
                    fixed3 colorD = max(dot(l, n) , 0) * _DiffuseColor * _LightColor0;
                    float3 h = normalize(l + v);
                    fixed3 colorS = pow(max(dot(n, h),0), _Shininess) * _SpecularColor * _LightColor0;
                    
                    return fixed4(colorA + colorD + colorS + pointLights(input).xyz , 1.0) ;
                }

            ENDCG
        }
    }
}
