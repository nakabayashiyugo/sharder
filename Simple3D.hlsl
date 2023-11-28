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
	float4		diffuseColor;		// ディフューズカラー（マテリアルの色）
	float4		light_vector;		//ライトの方向ベクトル
	float4		view_point;			//視点
	bool		isTexture;		// テクスチャ貼ってあるかどうか
};

//───────────────────────────────────────
// 頂点シェーダー出力＆ピクセルシェーダー入力データ構造体
//───────────────────────────────────────
struct VS_OUT
{
	float4 pos    : SV_POSITION;	//位置
	float2 uv	: TEXCOORD;	//UV座標
	float4 color	: COLOR;	//色（明るさ）
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

	//法線を回転
	normal = mul(normal, matW);

	outData.normal = normal;

	//light_vector = normalize(light_vector);
	outData.color = clamp(dot(normal, light_vector), 0, 1);

	//まとめて出力
	return outData;
}

//───────────────────────────────────────
// ピクセルシェーダ
//───────────────────────────────────────
float4 PS(VS_OUT inData) : SV_Target
{
	float4 lightSource = float4(1.0f, 1.0f, 1.0f, 1.0f);
	//return lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;//float4(1,1,1,1)
	float4 diffuse;
	float4 ambient;
	float4 specular;
	const float Ks = 2.0, n = 8.0;
	float4 view_vector;
	view_vector = inData.pos - view_point;

	if (isTexture == true) {
		diffuse = lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;
		ambient = lightSource * g_texture.Sample(g_sampler, inData.uv) * float4(0.3, 0.3, 0.3, 1);
		float4 r = 2 * inData.normal * dot(normalize(inData.normal), normalize(light_vector)) - light_vector;
		specular = pow(dot(normalize(r), normalize(view_vector)), n) * Ks * lightSource;
	}
	else 
	{
		diffuse = lightSource * diffuseColor * inData.color;
		ambient = lightSource * diffuseColor * float4(0.3, 0.3, 0.3, 1);
		specular = lightSource * diffuseColor * float4(0.3, 0.3, 0.3, 1);
	}
	
	return diffuse + specular + ambient;
	
	//float4 lightSource = float4(1.0, 1.0, 1.0, 1.0);
	//float4 ambientSource = float4(0.2, 0.2, 0.2, 1.0);
	//float4 diffuse;
	//float4 ambient;
	//if (isTexture == false)
	//{
	//	diffuse = lightSource * ambientSource * inData.color;
	//	ambient = lightSource * ambientSource * inData.color;
	//}
	//else
	//{
	//	diffuse = lightSource * ambientSource * inData.color;
	//	ambient = lightSource * ambientSource * inData.color;
	//}
	//float4 output = g_texture.Sample(g_sampler, inData.uv);

	//return output;
}
	