Shader "Custom/standardStripes"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (0,0,0,1)
        _Color2 ("Color 2", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
         _Tiling ("Tiling", Range(0, 500)) = 10
        _Direction ("Direction", Range(0, 1)) = 0
        _WarpScale ("Warp Scale", Range(0, 1)) = 0
        _WarpTiling ("Warp Tiling", Range(1, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color1;
        fixed4 _Color2;
        float _Tiling;
        float _Direction;
        float _WarpScale;
        float _WarpTiling;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            const float PI = 3.14159;
        
            float2 pos;
            pos.x = lerp(IN.uv_MainTex.x, IN.uv_MainTex.y, _Direction);
            pos.y = lerp(IN.uv_MainTex.y, 1 - IN.uv_MainTex.x, _Direction);
            pos.x += sin(pos.y * _WarpTiling * PI * 2) * _WarpScale;
            pos.x *= _Tiling;
            fixed2 mainUV = IN.uv_MainTex + pos;
            fixed value = floor(frac(pos.x) + 0.5);
        
            fixed4 c = tex2D (_MainTex, mainUV) * lerp(_Color1, _Color2, value);
            o.Albedo = c.rgb;
            
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}