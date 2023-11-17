#include "Arrow.h"
#include "Engine/Input.h"
#include "Engine/Model.h"
#include "Engine/SceneManager.h"
#include "Stage.h"
#include "Ball.h"
//コンストラクタ
Arrow::Arrow(GameObject* parent)
	: GameObject(parent, "Arrow"), hModel_(-1)
{
}

//初期化
void Arrow::Initialize()
{
	hModel_ = Model::Load("Assets\\Arrow.fbx");
	assert(hModel_ >= 0);
}

//更新
void Arrow::Update()
{
}

//描画
void Arrow::Draw()
{
	transform_.position_.y = 1;
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//開放
void Arrow::Release()
{
}