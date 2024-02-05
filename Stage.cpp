#include "Stage.h"
#include "Engine/Model.h"



//�R���X�g���N�^
Stage::Stage(GameObject* parent)
	: GameObject(parent, "Stage"), hModel_(-1)
{
}

//������
void Stage::Initialize()
{
	//���f���f�[�^�̃��[�h
	hModel_ = Model::Load("Assets\\Water.fbx");
	assert(hModel_ >= 0);

	//transform_.scale_ = XMFLOAT3(10, 1, 10);
	//transform_.rotate_.z = -90;

	
}

//�X�V
void Stage::Update()
{
	//transform_.rotate_.y += 1;
}

//�`��
void Stage::Draw()
{
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//�J��
void Stage::Release()
{
}