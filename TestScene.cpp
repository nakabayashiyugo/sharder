#include "TestScene.h"
#include"Engine/Input.h"
#include "Engine/SceneManager.h"
#include"Stage.h"
//�R���X�g���N�^
TestScene::TestScene(GameObject* parent)
	: GameObject(parent, "TestScene")
{
}

//������
void TestScene::Initialize()
{
}

//�X�V
void TestScene::Update()
{
	Instantiate<Stage>(this);
}

//�`��
void TestScene::Draw()
{
}

//�J��
void TestScene::Release()
{
}