#include "Ball.h"
#include "Engine/Input.h"
#include "Engine/Model.h"
#include "Engine/SceneManager.h"
#include "Stage.h"
//コンストラクタ
Ball::Ball(GameObject* parent)
	: GameObject(parent, "Ball"), hModel_(-1)
{
}

//初期化
void Ball::Initialize()
{
	hModel_ = Model::Load("Assets\\Ball.fbx");
	assert(hModel_ >= 0);
}

//更新
void Ball::Update()
{
	transform_.rotate_.x += 5;
	transform_.rotate_.y += 1;
}

//描画
void Ball::Draw()
{
	transform_.position_.x = 2;
	transform_.position_.y = 1;
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//開放
void Ball::Release()
{
}