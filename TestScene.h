#pragma once
#include "Engine/GameObject.h"
#include "Engine/Quad.h"

struct CBUFF_STAGESCENE
{
	XMFLOAT4	light_vector;		//ライトの方向ベクトル
	XMFLOAT4	view_point;			//視点

};

//■■シーンを管理するクラス
class TestScene : public GameObject
{
	ID3D11Buffer* pCBStageScene_;

	void InitConstantBuffer();
	XMFLOAT4 lightSourcePosition_;
public:
	//コンストラクタ
	//引数：parent  親オブジェクト（SceneManager）
	TestScene(GameObject* parent);

	//初期化
	void Initialize() override;

	//更新
	void Update() override;

	//描画
	void Draw() override;

	//開放
	void Release() override;
};