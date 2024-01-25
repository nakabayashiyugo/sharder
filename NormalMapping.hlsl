//������������������������������������������������������������������������������
// �e�N�X�`�����T���v���[�f�[�^�̃O���[�o���ϐ���`
//������������������������������������������������������������������������������
Texture2D	g_texture : register(t0);	//�e�N�X�`���[
SamplerState	g_sampler : register(s0);	//�T���v���[

Texture2D	normalTex : register(t1);

//������������������������������������������������������������������������������
// �R���X�^���g�o�b�t�@
// DirectX �����瑗�M����Ă���A�|���S�����_�ȊO�̏����̒�`
//������������������������������������������������������������������������������
cbuffer gmodel:register(b0)
{
	float4x4	matWVP;				// ���[���h�E�r���[�E�v���W�F�N�V�����̍����s��
	float4x4	matW;				//���[���h�s��
	float4x4	matNormal;
	float4		diffuseColor;		// �f�B�t���[�Y�J���[�i�}�e���A���̐F�j
	float4		ambientColor;
	float4		specularColor;
	float		shininess;
	bool		isTexture;			// �e�N�X�`���\���Ă��邩�ǂ���
	int			hasNormalMap;		//�m�[�}���}�b�v�����邩�ǂ���
};

cbuffer gmodel:register(b1)
{
	float4		lightPosition;
	float4		eyePosition;
};

//������������������������������������������������������������������������������
// ���_�V�F�[�_�[�o�́��s�N�Z���V�F�[�_�[���̓f�[�^�\����
//������������������������������������������������������������������������������
struct VS_OUT
{
	float4 pos		:SV_POSITION;	//�ʒu
	float2 uv		:TEXCOORD;		//UV���W
	float4 eyev		:POSITION;		//���[���h���W�ɕϊ����ꂽ�����x�N�g��
	float4 Neyev	:POSITION1;		//�m�[�}���}�b�v�p�̐ڋ�Ԃɕϊ����ꂽ�����x�N�g��
	float4 normal	:POSITION2;		//�@���x�N�g��
	float4 light	:POSITION3;		//���C�g��ڋ�Ԃɕϊ������x�N�g��
	float4 color	:POSITION4;		//�ʏ�̃����o�[�g���f���̊g�U���˂̐F
	
};

//������������������������������������������������������������������������������
// ���_�V�F�[�_
//������������������������������������������������������������������������������
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, 
			float4 normal : NORMAL, float4 tangent : TANGENT)
{
	//�s�N�Z���V�F�[�_�[�֓n�����
	VS_OUT outData = (VS_OUT)0;

	//���[�J�����W�ɁA���[���h�E�r���[�E�v���W�F�N�V�����s���������
	//�X�N���[�����W�ɕϊ����A�s�N�Z���V�F�[�_�[��
	outData.pos = mul(pos, matWVP);
	outData.uv = (float2)uv;

	float3 binormal = cross(normal, tangent);

	normal.w = 0;
	normal = mul(normal, matNormal);
	normal = normalize(normal);				//�@���x�N�g�������[�J�����W�ɕϊ��������
	outData.normal = normal;

	tangent.w = 0;
	tangent = mul(tangent, matNormal);
	tangent = normalize(tangent);			//�ڐ��x�N�g�������[�J�����W�ɕϊ��������

	binormal = mul(binormal, matNormal);
	binormal = normalize(binormal);			//�]�@���x�N�g�������[�J�����W�ɕϊ��������

	float4 posw = mul(pos, matW);
	outData.eyev = normalize(eyePosition - posw);		//���[���h���W�̎����x�N�g��

	outData.Neyev.x = dot(outData.eyev, tangent);	//�ڋ�Ԃ̎����x�N�g��
	outData.Neyev.y = dot(outData.eyev, binormal);
	outData.Neyev.z = dot(outData.eyev, normal);
	outData.Neyev.w = 0;

	float4 light = normalize(lightPosition);
	light.w = 0;
	light = normalize(light);

	outData.color = mul(light, outData.normal);
	outData.color.w = 0.0f;
	
	outData.light.x = dot(light, tangent);		//�ڋ�Ԃ̌����x�N�g��
	outData.light.y = dot(light, binormal);
	outData.light.z = dot(light, normal);
	outData.light.w = 0;

	//outData.light = float4(binormal.x, binormal.y, binormal.z, 0);

	//�܂Ƃ߂ďo��
	return outData;
}

//������������������������������������������������������������������������������
// �s�N�Z���V�F�[�_
//������������������������������������������������������������������������������
float4 PS(VS_OUT inData) : SV_Target
{
	//return inData.light;
	float4 lightSource = float4(1.0, 1.0, 1.0, 1.0);
	float4 diffuse;
	float4 ambient;

	if (hasNormalMap)
	{
		float4 tmpNormal = normalTex.Sample(g_sampler, inData.uv) * 2.0f - 1.0f;
		tmpNormal = normalize(tmpNormal);
		//tmpNormal.w = 0;

		float4 NL = clamp(dot(tmpNormal, inData.light), 0, 1);
		float4 S = dot(tmpNormal, normalize(inData.light));
		float4 reflection = reflect(-inData.light, tmpNormal);
		float4 specular = pow(saturate(dot(reflection, inData.Neyev)), 2) * specularColor;

		if (isTexture != 0)
		{
			diffuse = g_texture.Sample(g_sampler, inData.uv)* S;
			ambient = g_texture.Sample(g_sampler, inData.uv) * ambientColor;
		}
		else
		{
			diffuse = lightSource * diffuseColor * S;
			ambient = lightSource * diffuseColor * ambientColor;
		}
		//diffuse = diffuseColor * NL;

		return diffuse + ambient + specular;
	}
	else
	{
		float4 reflection = reflect(normalize(lightPosition), inData.normal);
		float4 specular = pow(saturate(dot(reflection, normalize(inData.eyev))), shininess) * specularColor;
		if (isTexture == 0)
		{
			diffuse = lightSource * diffuseColor * inData.color;
			ambient = lightSource * diffuseColor * ambientColor;
		}
		else
		{
			diffuse = lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;
			ambient = lightSource * g_texture.Sample(g_sampler, inData.uv) * ambientColor;
		}
		return diffuse + ambient + specular;
	}
}