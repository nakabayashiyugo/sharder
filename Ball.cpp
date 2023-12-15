#include "Engine/Input.h"
#include "Engine/Model.h"
#include "Engine/SceneManager.h"

#include "Ball.h"
#include "Stage.h"
#include "TestScene.h"

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
	transform_.scale_ = XMFLOAT3(0.2, 0.2, 0.2);
}

//�X�V
void Ball::Update()
{
    TestScene* pTest = (TestScene*)FindObject("TestScene");
    if (Input::IsKey(DIK_RIGHT))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x + 0.1f, p.y + 0.0f, p.z + 0.0f, p.w + 0.0f };
        transform_.position_.x += 0.1f;

        //Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
    if (Input::IsKey(DIK_LEFT))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x - 0.1f, p.y - 0.0f, p.z - 0.0f, p.w - 0.0f };
        transform_.position_.x -= 0.1f;

        /// Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
    if (Input::IsKey(DIK_UP))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x - 0.0f, p.y + 0.1f, p.z - 0.0f, p.w - 0.0f };
        transform_.position_.y += 0.1f;

        //Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
    if (Input::IsKey(DIK_DOWN))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x - 0.0f, p.y - 0.1f, p.z - 0.0f, p.w - 0.0f };
        transform_.position_.y -= 0.1f;

        //Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
    if (Input::IsKey(DIK_W))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x - 0.0f, p.y - 0.0f, p.z + 0.1f, p.w + 0.0f };
        transform_.position_.z += 0.1f;

        //Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
    if (Input::IsKey(DIK_S))
    {
        XMFLOAT4 p = pTest->GetLightPos();
        XMFLOAT4 margin{ p.x - 0.0f, p.y - 0.0f, p.z - 0.1f, p.w - 0.0f };
        transform_.position_.z -= 0.1f;

        //Model::GetModel(hModel_)->pTest->SetLightPos();(margin);
        pTest->SetLightPos(margin);
    }
}

//�`��
void Ball::Draw()
{
	//transform_.position_.x = 2;
	//transform_.position_.y = 1;
	Model::SetTransform(hModel_, transform_);
	Model::Draw(hModel_);
}

//�J��
void Ball::Release()
{
}