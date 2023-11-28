#include "Ball.h"
#include "Engine/Input.h"
#include "Engine/Model.h"
#include "Engine/SceneManager.h"
#include "Stage.h"
//�R���X�g���N�^
Ball::Ball(GameObject* parent)
	: GameObject(parent, "Ball"), hModel_(-1)
{
}

//������
void Ball::Initialize()
{
	hModel_ = Model::Load("Assets\\Ball.fbx");
	assert(hModel_ >= 0);
}

//�X�V
void Ball::Update()
{
	transform_.rotate_.x += 5;
	transform_.rotate_.y += 1;
}

//�`��
void Ball::Draw()
{
	transform_.position_.x = 2;
	transform_.position_.y = 1;
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//�J��
void Ball::Release()
{
}