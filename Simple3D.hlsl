//───────────────────────────────────────
// テクスチャ＆サンプラーデータのグローバル変数定義
//───────────────────────────────────────
Texture2D	g_texture : register(t0);	//テクスチャー
SamplerState	g_sampler : register(s0);	//サンプラー

//───────────────────────────────────────
// コンスタントバッファ
// DirectX 側から送信されてくる、ポリゴン頂点以外の諸情報の定義
//───────────────────────────────────────
cbuffer global
{
	float4x4	matWVP;			// ワールド・ビュー・プロジェクションの合成行列
	float4x4	matW;	//ワールド行列
	float4		light_vector;		//ライトの方向ベクトル
	float4		view_point;			//視点
	bool		isTexture;		// テクスチャ貼ってあるかどうか

	float4		diffuseColor;		// ディフューズカラー（マテリアルの色）
	float4		ambient;
	float4		specular;
	float		shininess;
};

//───────────────────────────────────────
// 頂点シェーダー出力＆ピクセルシェーダー入力データ構造体
//───────────────────────────────────────
struct VS_OUT
{
	float4 pos    : SV_POSITION;	//位置
	float2 uv	: TEXCOORD;	//UV座標
	float4 color	: COLOR;	//色（明るさ）
	float4 eyev		:POSITION;
	float4 normal	: NORMAL;
};

//───────────────────────────────────────
// 頂点シェーダ
//───────────────────────────────────────
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL)
{
	//ピクセルシェーダーへ渡す情報
	VS_OUT outData;

	//ローカル座標に、ワールド・ビュー・プロジェクション行列をかけて
	//スクリーン座標に変換し、ピクセルシェーダーへ
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;
	normal.w = 0;
	normal = mul(normal, matW);
	outData.normal = normal;

	float light = normalize(light_vector);
	light = normalize(light);
	outData.color = saturate(dot(normal, light));
	float posw = mul(pos, matW);
	outData.eyev = view_point - posw;

	//まとめて出力
	return outData;
}

//───────────────────────────────────────
// ピクセルシェーダ
//───────────────────────────────────────
float4 PS(VS_OUT inData) : SV_Target
{
	float4 lightSource = float4(1.0f, 1.0f, 1.0f, 1.0f);
	float4 ambientSource = float4(0.5f, 0.5f, 0.5f, 1);
	float4 dif;
	float4 amb;
	float4 NL = saturate(dot(inData.normal, normalize(light_vector)));
	float4 r = normalize(2 * inData.normal * NL - normalize(light_vector));
	float4 spe = pow(saturate(dot(r, normalize(inData.eyev))), 8);
	

	if (isTexture == true) {
		dif = lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;
		amb = lightSource * g_texture.Sample(g_sampler, inData.uv) * ambientSource;
	}
	else 
	{
		dif = lightSource * diffuseColor * inData.color;
		amb = lightSource * diffuseColor * ambientSource;
	}
	
	return dif + amb + spe;
}
	