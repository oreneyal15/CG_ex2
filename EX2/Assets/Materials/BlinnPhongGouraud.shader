Shader "CG/BlinnPhongGouraud"
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
                    fixed4 color : COLOR0;
                };


                v2f vert (appdata input)
                {
                    v2f output;
                    output.pos = UnityObjectToClipPos(input.vertex);
                    float3 v = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, input.vertex));
                    float3 l = normalize(_WorldSpaceLightPos0);
                    float3 n = normalize( mul(unity_ObjectToWorld, input.normal));
                    fixed3 colorA = _AmbientColor * _LightColor0;
                    fixed3 colorD = max(dot(l, n) , 0) * _DiffuseColor * _LightColor0;
                    float3 h = normalize(l + v);
                    fixed3 colorS = pow(max(dot(n, h),0), _Shininess) * _SpecularColor * _LightColor0;
                    output.color = fixed4(colorA + colorD + colorS, 1.0);
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    return input.color;
                }

            ENDCG
        }
    }
}
