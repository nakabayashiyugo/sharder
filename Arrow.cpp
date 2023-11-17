#include "Arrow.h"
#include "Engine/Input.h"
#include "Engine/Model.h"
#include "Engine/SceneManager.h"
#include "Stage.h"
#include "Ball.h"
//�R���X�g���N�^
Arrow::Arrow(GameObject* parent)
	: GameObject(parent, "Arrow"), hModel_(-1)
{
}

//������
void Arrow::Initialize()
{
	hModel_ = Model::Load("Assets\\Arrow.fbx");
	assert(hModel_ >= 0);
}

//�X�V
void Arrow::Update()
{
}

//�`��
void Arrow::Draw()
{
	transform_.position_.y = 1;
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//�J��
void Arrow::Release()
{
}