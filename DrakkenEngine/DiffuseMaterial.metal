//
//  DKRSpritesheetMaterial.metal
//  DrakkenEngine
//
//  Created by Allison Lindner on 17/08/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ModelUniform {
	float4x4 modelMatrix;
};

struct CameraUniform {
	float4x4 viewMatrix;
	float4x4 projectionMatrix;
};

struct Light {
	float3 color;
	float intensity;
};

struct VertexOut {
	float4 position		[[ position ]];
	float4 normal;
	float2 texCoord;
};

vertex VertexOut diffuse_vertex (constant		CameraUniform	&uScene			[[ buffer(0) ]] ,
								 constant		float4x4			*uModelMatrix	[[ buffer(1) ]] ,
								 constant		float4			*pPosition		[[ buffer(2) ]] ,
								 constant		float4			*pNormal			[[ buffer(3) ]] ,
								 constant		uint				&pVerticesCount	[[ buffer(4)	 ]] ,
								 constant		float2			*pTexCoord		[[ buffer(5) ]] ,
								 constant		uint				*pTexCoordIndex	[[ buffer(6)	 ]] ,
												uint				vid				[[ vertex_id ]] ,
												uint				iid				[[ instance_id ]]) {
	VertexOut out;
	
	out.position =	uScene.projectionMatrix *
					uScene.viewMatrix *
					uModelMatrix[iid] *
					pPosition[vid];
	
	out.normal = uModelMatrix[iid] * pNormal[vid];
	
	uint index = pTexCoordIndex[iid];
	out.texCoord = pTexCoord[(index * pVerticesCount) + vid];
	
	return out;
}

fragment float4 diffuse_fragment (			VertexOut			in			[[ stage_in   ]] ,
								 constant	Light				&uLight		[[ buffer(0)  ]] ,
											texture2d<float>		texture		[[ texture(0) ]] ,
											sampler				s			[[ sampler(0) ]] ) {
	
	float4 color = texture.sample(s, in.texCoord);
	float3 alColor = uLight.color.xyz * uLight.intensity;
	
	return saturate(color * float4(alColor, 1.0));
}
