#include "TestScene.h"
#include "Engine/Input.h"
#include "Engine/SceneManager.h"
#include "Engine//Camera.h"

#include "Stage.h"
#include "Ball.h"
#include "Arrow.h"

namespace {
	const XMFLOAT4 DEF_LIGHT_POSITION{ 0, 1, -1, 0 };
}

void TestScene::InitConstantBuffer()
{
	D3D11_BUFFER_DESC cb;
	cb.ByteWidth = sizeof(CBUFF_STAGESCENE);
	cb.Usage = D3D11_USAGE_DEFAULT;
	cb.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	cb.CPUAccessFlags = 0;
	cb.MiscFlags = 0;
	cb.StructureByteStride = 0;

	HRESULT hr;
	hr = Direct3D::pDevice_->CreateBuffer(&cb, nullptr, &pCBStageScene_);
	if (FAILED(hr))
	{
		MessageBox(NULL, "コンスタントバッファの作成に失敗しました", "エラー", MB_OK);
	}

}

//コンストラクタ
TestScene::TestScene(GameObject* parent)
	: GameObject(parent, "TestScene"), lightSourcePosition_(DEF_LIGHT_POSITION)
{
}

//初期化
void TestScene::Initialize()
{
	//Instantiate<Stage>(this);
	//Instantiate<Ball>(this);
	Instantiate<Arrow>(this);

	InitConstantBuffer();
}

//更新
void TestScene::Update()
{
	CBUFF_STAGESCENE cb;
	cb.lightPosition = lightSourcePosition_;
	XMStoreFloat4(&cb.eyePosition, Camera::GetPosition());

	Direct3D::pContext_->UpdateSubresource(pCBStageScene_, 0, NULL, &cb, 0, 0);

	Direct3D::pContext_->VSSetConstantBuffers(1, 1, &pCBStageScene_);
	Direct3D::pContext_->PSSetConstantBuffers(1, 1, &pCBStageScene_);
}

//描画
void TestScene::Draw()
{
}

//開放
void TestScene::Release()
{
}