#include "Stage.h"
#include "Engine/Model.h"
//コンストラクタ
Stage::Stage(GameObject* parent)
	: GameObject(parent, "Stage"), hModel_(-1)
{
}

//初期化
void Stage::Initialize()
{
	//モデルデータのロード
	hModel_ = Model::Load("Assets\\donatu.fbx");
	assert(hModel_ >= 0);

	//transform_.scale_ = XMFLOAT3(10, 1, 10);
}

//更新
void Stage::Update()
{
}

//描画
void Stage::Draw()
{
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//開放
void Stage::Release()
{
}