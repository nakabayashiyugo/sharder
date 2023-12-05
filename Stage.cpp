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
	hModel_ = Model::Load("Assets\\donatu.fbx");
	assert(hModel_ >= 0);

	//transform_.scale_ = XMFLOAT3(10, 1, 10);
}

//�X�V
void Stage::Update()
{
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