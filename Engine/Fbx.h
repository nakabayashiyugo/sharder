#pragma once

#include <d3d11.h>
#include <fbxsdk.h>
#include <string>
#include<vector>
#include "Transform.h"
#include"Direct3D.h"
#include"Transform.h"
#include"Camera.h"
#include"Texture.h"

using std::vector;

#pragma comment(lib, "LibFbxSDK-MD.lib")
#pragma comment(lib, "LibXml2-MD.lib")
#pragma comment(lib, "zlib-MD.lib")
//class Texture;//�|�C���^�Ȃ炱���OK(�w�b�_���C���N���[�h���Ȃ��Ă���)
class Fbx
{
	//�}�e���A��
	struct MATERIAL
	{
		Texture*	pTexture;
		Texture*	pNormalTexture;
		XMFLOAT4	diffuse;
		XMFLOAT4	ambient;
		XMFLOAT4	specular;
		float		shininess;
	};
	struct CONSTANT_BUFFER
	{
		XMMATRIX	matWVP;
		XMMATRIX	matW;
		XMMATRIX	matNormal;
		XMFLOAT4	diffuseColor;		// �f�B�t���[�Y�J���[�i�}�e���A���̐F�j
		XMFLOAT4	ambientColor;
		XMFLOAT4	specularColor;
		float		shininess;
		int			isTextured;		// �e�N�X�`���\���Ă��邩�ǂ���
		
	};

	struct VERTEX
	{
		XMVECTOR position;	//�ʒu
		XMVECTOR uv;		//�|���S����
		XMVECTOR normal;	//�@���x�N�g��
		XMVECTOR tangent;	//�ڐ�
	};

	int vertexCount_;	//���_��
	int polygonCount_;	//�|���S����
	int materialCount_;	//�}�e���A���̌�

	ID3D11Buffer* pVertexBuffer_;
	ID3D11Buffer** pIndexBuffer_;
	ID3D11Buffer* pConstantBuffer_;
	MATERIAL* pMaterialList_;
	vector<int>index_Count_;
	Texture* pToonTex_;

public:

	Fbx();
	HRESULT Load(std::string fileName);
	void    InitVertex(fbxsdk::FbxMesh* mesh);
	void    InitIndex(fbxsdk::FbxMesh* mesh);
	void    IntConstantBuffer();	//�R���X�^���g�o�b�t�@����
	void    InitMaterial(fbxsdk::FbxNode* pNode);
	void    Draw(Transform& transform);
	void	DrawOutLine(Transform& transform);
	void    Release();
};
