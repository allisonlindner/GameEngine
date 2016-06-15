//
//  Math.swift
//  HelloMetal
//
//  Created by Vinícius Godoy on 02/09/15.
//  Copyright © 2015 BEPiD. All rights reserved.
//

import simd

public class DKMath {
	static let EPSILON = Float(0.000001)

	//General matrices functions
	//--------------------------

	static public func newMatrix(_ values : [Float]) -> float4x4 {
		let P = float4(values[ 0], values[ 1], values[ 2], values[ 3])
		let Q = float4(values[ 4], values[ 5], values[ 6], values[ 7])
		let R = float4(values[ 8], values[ 9], values[10], values[11])
		let S = float4(values[12], values[13], values[14], values[15])
		
		return float4x4([P, Q, R, S])
	}

	static public func toRadians(_ degrees : Float) -> Float {
		return degrees * Float(M_PI) / 180.0
	}

	static public func toDegrees(_ radians : Float) -> Float {
		return radians * 180.0 / Float(M_PI)
	}

	//Projection matrices
	//-------------------

	static public func newPerspective(_ fovy: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
		let f = 1.0 / tan(fovy / 2.0)
		let nf = 1.0 / (near - far)
		
		return DKMath.newMatrix([
			f / aspect, 0,                          0,  0,
			0,          f,                          0,  0,
			0,          0,          (far + near) * nf, -1,
			0,          0,    (2.0 * far * near) * nf,  0])
	}

	static public func newOrtho(_ left: Float, right: Float, bottom: Float, top : Float, near: Float, far: Float) -> float4x4 {
		let lr = 1.0 / (left - right)
		let bt = 1.0 / (bottom - top)
		let nf = 1.0 / (near - far)
		
		return DKMath.newMatrix([
					  -2.0 * lr,                   0.0,                 0.0,         0.0,
							0.0,             -2.0 * bt,                 0.0,         0.0,
							0.0,                   0.0,              2 * nf,         0.0,
			(left + right) * lr,   (top + bottom) * bt,   (far + near) * nf,         1.0
		]);
	}

	//View matrices
	//-------------

	static public func newLookAt(_ eye: float3, center: float3, up: float3) -> float4x4 {
		var z0 = eye.x - center.x;
		var z1 = eye.y - center.y;
		var z2 = eye.z - center.z;

		if (abs(z0) < DKMath.EPSILON && abs(z1) < EPSILON && abs(z2) < EPSILON) {
				return float4x4(1.0);
		}
		
		var len = 1.0 / sqrt(z0 * z0 + z1 * z1 + z2 * z2)
		z0 *= len
		z1 *= len
		z2 *= len
		
		var x0 = up.y * z2 - up.z * z1;
		var x1 = up.z * z0 - up.x * z2;
		var x2 = up.x * z1 - up.y * z0;
		len = sqrt(x0 * x0 + x1 * x1 + x2 * x2);
		if (len <= EPSILON) {
			x0 = 0.0;
			x1 = 0.0;
			x2 = 0.0;
		} else {
			len = 1.0 / len;
			x0 *= len;
			x1 *= len;
			x2 *= len;
		}
		
		var y0 = z1 * x2 - z2 * x1;
		var y1 = z2 * x0 - z0 * x2;
		var y2 = z0 * x1 - z1 * x0;
		len = sqrt(y0 * y0 + y1 * y1 + y2 * y2);
		if (len <= EPSILON) {
			y0 = 0.0;
			y1 = 0.0;
			y2 = 0.0;
		} else {
			len = 1.0 / len;
			y0 *= len;
			y1 *= len;
			y2 *= len;
		}
		
		let dx = (x0 * eye.x + x1 * eye.y + x2 * eye.z)
		let dy = (y0 * eye.x + y1 * eye.y + y2 * eye.z)
		let dz = (z0 * eye.x + z1 * eye.y + z2 * eye.z)
		
		return DKMath.newMatrix([
			x0,  y0,  z0, 0.0,
			x1,  y1,  z1, 0.0,
			x2,  y2,  z2, 0.0,
		   -dx, -dy, -dz, 1.0
		]);
	}

	//Model matrices
	//--------------

	static public func newScale(_ scale: Float) -> float4x4 {
		return DKMath.newScale(scale, y: scale, z: scale);
	}

	static public func newScale(_ x: Float, y: Float, z: Float) -> float4x4 {
		return DKMath.newMatrix([
			  x, 0.0, 0.0, 0.0,
			0.0,   y, 0.0, 0.0,
			0.0, 0.0,   z, 0.0,
			0.0, 0.0, 0.0, 1.0
		]);
	}

	static public func newTranslation(_ p: float3) -> float4x4 {
		return DKMath.newMatrix([
			  1,   0,   0,   0,
			  0,   1,   0,   0,
			  0,   0,   1,   0,
			p.x, p.y, p.z,   1
		]);
	}

	static public func newRotation(_ angle: Float, axis : float3) -> float4x4 {
		var len = length(axis);
		
		if (len <= EPSILON) {
			return float4x4(1.0)
		}
		
		len = 1.0 / len
		
		let x = axis.x * len
		let y = axis.y * len
		let z = axis.z * len
		
		let s = sin(angle);
		let c = cos(angle);
		let t = 1.0 - c;
		
		let A = x * x * t + c
		let B = y * x * t + z * s
		let C = z * x * t - y * s
		
		let D = x * y * t - z * s
		let E = y * y * t + c
		let F = z * y * t + x * s
		
		let G = x * z * t + y * s
		let H = y * z * t - x * s
		let I = z * z * t + c
		
		return DKMath.newMatrix([
			A,		B,		C,		0.0,
			D,		E,		F,		0.0,
			G,		H,		I,		0.0,
			0.0,		0.0,	0.0,	1.0
		])
	}

	static public func newRotationX(_ angle: Float) -> float4x4 {
		let s = sin(angle)
		let c = cos(angle)
		return DKMath.newMatrix([
			1.0, 0.0, 0.0, 0.0,
			0.0,   c,   s, 0.0,
			0.0,  -s,   c, 0.0,
			0.0, 0.0, 0.0, 1.0
		])
	}

	static public func newRotationY(_ angle: Float) -> float4x4 {
		let s = sin(angle)
		let c = cos(angle)
		return DKMath.newMatrix([
			  c, 0.0,  -s, 0.0,
			0.0, 1.0, 0.0, 0.0,
			  s, 0.0,   c, 0.0,
			0.0, 0.0, 0.0, 1.0
		])
	}

	static public func newRotationZ(_ angle: Float) -> float4x4 {
		let s = sin(angle)
		let c = cos(angle)
		return DKMath.newMatrix([
			  c,   s, 0.0, 0.0,
			 -s,   c, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0
		])
	}
}
