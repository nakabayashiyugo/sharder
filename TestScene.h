#pragma once
#include "Engine/GameObject.h"
#include "Engine/Quad.h"

struct CBUFF_STAGESCENE
{
	XMFLOAT4	light_vector;		//���C�g�̕����x�N�g��
	XMFLOAT4	view_point;			//���_

};

//�����V�[�����Ǘ�����N���X
class TestScene : public GameObject
{
	ID3D11Buffer* pCBStageScene_;

	void InitConstantBuffer();
	XMFLOAT4 lightSourcePosition_;
public:
	//�R���X�g���N�^
	//�����Fparent  �e�I�u�W�F�N�g�iSceneManager�j
	TestScene(GameObject* parent);

	//������
	void Initialize() override;

	//�X�V
	void Update() override;

	//�`��
	void Draw() override;

	//�J��
	void Release() override;
};