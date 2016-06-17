//
//  DKRDiffuseMaterial.metal
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
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

struct SpriteUniform {
	Light l;
};

struct VertexOut {
	float4 position		[[ position ]];
	float4 normal;
	float2 texCoord;
};

vertex VertexOut sprite_vertex (constant		CameraUniform	&uScene			[[ buffer(0) ]] ,
								constant		ModelUniform		*uModel			[[ buffer(1) ]] ,
								constant		float4			*pPosition		[[ buffer(2) ]] ,
								constant		float4			*pNormal			[[ buffer(3) ]] ,
								constant		float2			*pTexCoord		[[ buffer(4) ]] ,
											uint				vid				[[ vertex_id ]] ,
											uint				iid				[[ instance_id ]]) {
	VertexOut out;
	
	out.position =  uScene.projectionMatrix *
					uScene.viewMatrix *
					uModel[iid].modelMatrix *
					pPosition[vid];
	
	out.normal = uModel[iid].modelMatrix * pNormal[vid];
	
	out.texCoord = pTexCoord[vid];
	
	return out;
}

fragment float4 sprite_fragment (			VertexOut			in			[[ stage_in   ]] ,
								  constant	SpriteUniform		&uSprite		[[ buffer(0)  ]] ,
											texture2d<float>		texture		[[ texture(0) ]] ,
											sampler				s			[[ sampler(0) ]] ) {
	
	float4 color = texture.sample(s, in.texCoord);
	float3 alColor = uSprite.l.color.xyz * uSprite.l.intensity;
	
	return saturate(color * float4(alColor, 1.0));
}