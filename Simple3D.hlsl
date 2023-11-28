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
	float4		diffuseColor;		// �f�B�t���[�Y�J���[�i�}�e���A���̐F�j
	float4		light_vector;		//���C�g�̕����x�N�g��
	float4		view_point;			//���_
	bool		isTexture;		// �e�N�X�`���\���Ă��邩�ǂ���
};

//������������������������������������������������������������������������������
// ���_�V�F�[�_�[�o�́��s�N�Z���V�F�[�_�[���̓f�[�^�\����
//������������������������������������������������������������������������������
struct VS_OUT
{
	float4 pos    : SV_POSITION;	//�ʒu
	float2 uv	: TEXCOORD;	//UV���W
	float4 color	: COLOR;	//�F�i���邳�j
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

	//�@������]
	normal = mul(normal, matW);
	
	//light_vector = normalize(light_vector);
	outData.color = clamp(dot(normal, light_vector), 0, 1);

	//�܂Ƃ߂ďo��
	return outData;
}

//������������������������������������������������������������������������������
// �s�N�Z���V�F�[�_
//������������������������������������������������������������������������������
float4 PS(VS_OUT inData) : SV_Target
{
	float4 lightSource = float4(1.0f, 1.0f, 1.0f, 1.0f);
	//return lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;//float4(1,1,1,1)
	float4 diffuse;
	float4 ambient;
	float4 specular;
	const float Ks = 2.0, n = 8.0;
	float4 view_vector;
	view_vector = inData.pos - view_point;

	if (isTexture == true) {
		diffuse = lightSource * g_texture.Sample(g_sampler, inData.uv) * inData.color;
		ambient = lightSource * g_texture.Sample(g_sampler, inData.uv) * float4(0.3, 0.3, 0.3, 1);
		float4 r = 2 * matW * dot(matW, light_vector) - light_vector;
		specular = (pow(dot(normalize(r), normalize(view_vector), n)) * Ks * lightSource;
	}
	else {
		diffuse = lightSource * diffuseColor * inData.color;
		ambient = lightSource * diffuseColor * float4(0.3, 0.3, 0.3, 1);
	}
	
	
	
	return diffuse + ambient + supecular;

	/*float4 lightSource = float4(1.0, 1.0, 1.0, 1.0);
	float4 ambientSource = float4(0.2, 0.2, 0.2, 1.0);
	float4 diffuse;
	float4 ambient;
	if (isTexture == false)
	{
		diffuse = lightSource * ambientSource * inData.color;
		ambient = lightSource * ambientSource * inData.color;
	}
	else
	{
		diffuse = lightSource * ambientSource * inData.color;
		ambient = lightSource * ambientSource * inData.color;
	}*/
	float4 output = g_texture.Sample(g_sampler, inData.uv);

	return output;
}
	