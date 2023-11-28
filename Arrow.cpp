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
	t[0].position_.y = 1;
	t[0].rotate_.z = 90;
	t[1].position_.x = 1;
	t[2].position_.z = 1;
	t[2].rotate_.y = -90;
}

//�X�V
void Arrow::Update()
{
}

//�`��
void Arrow::Draw()
{
	for (int i = 0; i < 3; i++)
	{
		Model::SetTransform(hModel_, t[i]);
		Model::Draw(hModel_);
	}
	
}

//�J��
void Arrow::Release()
{
}