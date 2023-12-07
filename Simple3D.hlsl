//������������������������������������������������������������������������������
// �e�N�X�`�����T���v���[�f�[�^�̃O���[�o���ϐ���`
//������������������������������������������������������������������������������
Texture2D	g_texture : register(t0);	//�e�N�X�`���[
SamplerState	g_sampler : register(s0);	//�T���v���[

//������������������������������������������������������������������������������
// �R���X�^���g�o�b�t�@
// DirectX �����瑗�M����Ă���A�|���S�����_�ȊO�̏����̒�`
//������������������������������������������������������������������������������
cbuffer global
{
	float4x4	matWVP;			// ���[���h�E�r���[�E�v���W�F�N�V�����̍����s��
	float4x4	matW;	//���[���h�s��
	float4		light_vector;		//���C�g�̕����x�N�g��
	float4		view_point;			//���_
	bool		isTexture;		// �e�N�X�`���\���Ă��邩�ǂ���

	float4		diffuseColor;		// �f�B�t���[�Y�J���[�i�}�e���A���̐F�j
	float4		ambient;
	float4		specular;
	float		shininess;
};

//������������������������������������������������������������������������������
// ���_�V�F�[�_�[�o�́��s�N�Z���V�F�[�_�[���̓f�[�^�\����
//������������������������������������������������������������������������������
struct VS_OUT
{
	float4 pos    : SV_POSITION;	//�ʒu
	float2 uv	: TEXCOORD;	//UV���W
	float4 color	: COLOR;	//�F�i���邳�j
	float4 eyev		:POSITION;
	float4 normal	: NORMAL;
};

//������������������������������������������������������������������������������
// ���_�V�F�[�_
//������������������������������������������������������������������������������
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL)
{
	//�s�N�Z���V�F�[�_�[�֓n�����
	VS_OUT outData;

	//���[�J�����W�ɁA���[���h�E�r���[�E�v���W�F�N�V�����s���������
	//�X�N���[�����W�ɕϊ����A�s�N�Z���V�F�[�_�[��
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;
	normal.w = 0;
	normal = mul(normal, matW);
	outData.normal = normal;

	float light = normalize(light_vector);
	light = normalize(light);
	outData.color = saturate(dot(normal, light));
	float posw = mul(pos, matW);
	outData.eyev = view_point - posw;

	//�܂Ƃ߂ďo��
	return outData;
}

//������������������������������������������������������������������������������
// �s�N�Z���V�F�[�_
//������������������������������������������������������������������������������
float4 PS(VS_OUT inData) : SV_Target
{
	float4 lightSource = float4(1.0f, 1.0f, 1.0f, 1.0f);
	float4 ambientSource = float4(0.5f, 0.5f, 0.5f, 1);
	float4 dif;
	float4 amb;
	float4 NL = saturate(dot(inData.normal, normalize(light_vector)));
	float4 r = normalize(2 * inData.normal * NL - normalize(light_vector));
	float4 spe = pow(saturate(dot(r, normalize(inData.eyev))), 8);
	

	if (isTexture == true) {
		dif = lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;
		amb = lightSource * g_texture.Sample(g_sampler, inData.uv) * ambientSource;
	}
	else 
	{
		dif = lightSource * diffuseColor * inData.color;
		amb = lightSource * diffuseColor * ambientSource;
	}
	
	return dif + amb + spe;
}
	