//
//  Matrix4x4.swift
//  MathKit
//
//  Created by Marcelo Chaves on 04/05/19.
//  Copyright © 2019 Marcelo Chaves. All rights reserved.
//

import Foundation

public struct Matrix4x4 {
    public var m11: Scalar
    public var m12: Scalar
    public var m13: Scalar
    public var m14: Scalar
    public var m21: Scalar
    public var m22: Scalar
    public var m23: Scalar
    public var m24: Scalar
    public var m31: Scalar
    public var m32: Scalar
    public var m33: Scalar
    public var m34: Scalar
    public var m41: Scalar
    public var m42: Scalar
    public var m43: Scalar
    public var m44: Scalar
}

extension Matrix4x4: Hashable {
    public var hashValue: Int {
        var hash = m11.hashValue &+ m12.hashValue &+ m13.hashValue &+ m14.hashValue
        hash = hash &+ m21.hashValue &+ m22.hashValue &+ m23.hashValue &+ m24.hashValue
        hash = hash &+ m31.hashValue &+ m32.hashValue &+ m33.hashValue &+ m34.hashValue
        hash = hash &+ m41.hashValue &+ m42.hashValue &+ m43.hashValue &+ m44.hashValue
        return hash
    }
}

public extension Matrix4x4 {
    public static let identity = Matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    
    public init(_ m11: Scalar, _ m12: Scalar, _ m13: Scalar, _ m14: Scalar,
                _ m21: Scalar, _ m22: Scalar, _ m23: Scalar, _ m24: Scalar,
                _ m31: Scalar, _ m32: Scalar, _ m33: Scalar, _ m34: Scalar,
                _ m41: Scalar, _ m42: Scalar, _ m43: Scalar, _ m44: Scalar) {
        self.m11 = m11 // 0
        self.m12 = m12 // 1
        self.m13 = m13 // 2
        self.m14 = m14 // 3
        self.m21 = m21 // 4
        self.m22 = m22 // 5
        self.m23 = m23 // 6
        self.m24 = m24 // 7
        self.m31 = m31 // 8
        self.m32 = m32 // 9
        self.m33 = m33 // 10
        self.m34 = m34 // 11
        self.m41 = m41 // 12
        self.m42 = m42 // 13
        self.m43 = m43 // 14
        self.m44 = m44 // 15
    }
    
    public init(scale s: Vector3) {
        self.init(
            s.x, 0, 0, 0,
            0, s.y, 0, 0,
            0, 0, s.z, 0,
            0, 0, 0, 1
        )
    }
    
    public init(translation t: Vector3) {
        self.init(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            t.x, t.y, t.z, 1
        )
    }
    
    public init(rotation axisAngle: Vector4) {
        self.init(quaternion: Quaternion(axisAngle: axisAngle))
    }
    
    public init(quaternion q: Quaternion) {
        self.init(
            1 - 2 * (q.y * q.y + q.z * q.z), 2 * (q.x * q.y + q.z * q.w), 2 * (q.x * q.z - q.y * q.w), 0,
            2 * (q.x * q.y - q.z * q.w), 1 - 2 * (q.x * q.x + q.z * q.z), 2 * (q.y * q.z + q.x * q.w), 0,
            2 * (q.x * q.z + q.y * q.w), 2 * (q.y * q.z - q.x * q.w), 1 - 2 * (q.x * q.x + q.y * q.y), 0,
            0, 0, 0, 1
        )
    }
    
    public init(fovx: Scalar, fovy: Scalar, near: Scalar, far: Scalar) {
        self.init(fovy: fovy, aspect: fovx / fovy, near: near, far: far)
    }
    
    public init(fovx: Scalar, aspect: Scalar, near: Scalar, far: Scalar) {
        self.init(fovy: fovx / aspect, aspect: aspect, near: near, far: far)
    }
    
    public init(fovy: Scalar, aspect: Scalar, near: Scalar, far: Scalar) {
        let dz = far - near
        
        assert(dz > 0, "far value must be greater than near")
        assert(fovy > 0, "field of view must be nonzero and positive")
        assert(aspect > 0, "aspect ratio must be nonzero and positive")
        
        let r = fovy / 2
        let cotangent = cos(r) / sin(r)
        
        self.init(
            cotangent / aspect, 0, 0, 0,
            0, cotangent, 0, 0,
            0, 0, -(far + near) / dz, -1,
            0, 0, -2 * near * far / dz, 0
        )
    }
    
    public init(top: Scalar, right: Scalar, bottom: Scalar, left: Scalar, near: Scalar, far: Scalar) {
        let dx = right - left
        let dy = top - bottom
        let dz = far - near
        
        self.init(
            2 / dx, 0, 0, 0,
            0, 2 / dy, 0, 0,
            0, 0, -2 / dz, 0,
            -(right + left) / dx, -(top + bottom) / dy, -(far + near) / dz, 1
        )
    }
    
    public init(_ m: [Scalar]) {
        assert(m.count == 16, "array must contain 16 elements, contained \(m.count)")
        
        m11 = m[0]
        m12 = m[1]
        m13 = m[2]
        m14 = m[3]
        m21 = m[4]
        m22 = m[5]
        m23 = m[6]
        m24 = m[7]
        m31 = m[8]
        m32 = m[9]
        m33 = m[10]
        m34 = m[11]
        m41 = m[12]
        m42 = m[13]
        m43 = m[14]
        m44 = m[15]
    }
    
    public func toArray() -> [Scalar] {
        return [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44]
    }
    
    public var adjugate: Matrix4x4 {
        var m = Matrix4x4.identity
        
        m.m11 = m22 * m33 * m44 - m22 * m34 * m43
        m.m11 += -m32 * m23 * m44 + m32 * m24 * m43
        m.m11 += m42 * m23 * m34 - m42 * m24 * m33
        
        m.m21 = -m21 * m33 * m44 + m21 * m34 * m43
        m.m21 += m31 * m23 * m44 - m31 * m24 * m43
        m.m21 += -m41 * m23 * m34 + m41 * m24 * m33
        
        m.m31 = m21 * m32 * m44 - m21 * m34 * m42
        m.m31 += -m31 * m22 * m44 + m31 * m24 * m42
        m.m31 += m41 * m22 * m34 - m41 * m24 * m32
        
        m.m41 = -m21 * m32 * m43 + m21 * m33 * m42
        m.m41 += m31 * m22 * m43 - m31 * m23 * m42
        m.m41 += -m41 * m22 * m33 + m41 * m23 * m32
        
        m.m12 = -m12 * m33 * m44 + m12 * m34 * m43
        m.m12 += m32 * m13 * m44 - m32 * m14 * m43
        m.m12 += -m42 * m13 * m34 + m42 * m14 * m33
        
        m.m22 = m11 * m33 * m44 - m11 * m34 * m43
        m.m22 += -m31 * m13 * m44 + m31 * m14 * m43
        m.m22 += m41 * m13 * m34 - m41 * m14 * m33
        
        m.m32 = -m11 * m32 * m44 + m11 * m34 * m42
        m.m32 += m31 * m12 * m44 - m31 * m14 * m42
        m.m32 += -m41 * m12 * m34 + m41 * m14 * m32
        
        m.m42 = m11 * m32 * m43 - m11 * m33 * m42
        m.m42 += -m31 * m12 * m43 + m31 * m13 * m42
        m.m42 += m41 * m12 * m33 - m41 * m13 * m32
        
        m.m13 = m12 * m23 * m44 - m12 * m24 * m43
        m.m13 += -m22 * m13 * m44 + m22 * m14 * m43
        m.m13 += m42 * m13 * m24 - m42 * m14 * m23
        
        m.m23 = -m11 * m23 * m44 + m11 * m24 * m43
        m.m23 += m21 * m13 * m44 - m21 * m14 * m43
        m.m23 += -m41 * m13 * m24 + m41 * m14 * m23
        
        m.m33 = m11 * m22 * m44 - m11 * m24 * m42
        m.m33 += -m21 * m12 * m44 + m21 * m14 * m42
        m.m33 += m41 * m12 * m24 - m41 * m14 * m22
        
        m.m43 = -m11 * m22 * m43 + m11 * m23 * m42
        m.m43 += m21 * m12 * m43 - m21 * m13 * m42
        m.m43 += -m41 * m12 * m23 + m41 * m13 * m22
        
        m.m14 = -m12 * m23 * m34 + m12 * m24 * m33
        m.m14 += m22 * m13 * m34 - m22 * m14 * m33
        m.m14 += -m32 * m13 * m24 + m32 * m14 * m23
        
        m.m24 = m11 * m23 * m34 - m11 * m24 * m33
        m.m24 += -m21 * m13 * m34 + m21 * m14 * m33
        m.m24 += m31 * m13 * m24 - m31 * m14 * m23
        
        m.m34 = -m11 * m22 * m34 + m11 * m24 * m32
        m.m34 += m21 * m12 * m34 - m21 * m14 * m32
        m.m34 += -m31 * m12 * m24 + m31 * m14 * m22
        
        m.m44 = m11 * m22 * m33 - m11 * m23 * m32
        m.m44 += -m21 * m12 * m33 + m21 * m13 * m32
        m.m44 += m31 * m12 * m23 - m31 * m13 * m22
        
        return m
    }
    
    private func determinant(forAdjugate m: Matrix4x4) -> Scalar {
        return m11 * m.m11 + m12 * m.m21 + m13 * m.m31 + m14 * m.m41
    }
    
    public var determinant: Scalar {
        return determinant(forAdjugate: adjugate)
    }
    
    public var transpose: Matrix4x4 {
        return Matrix4x4(
            m11, m21, m31, m41,
            m12, m22, m32, m42,
            m13, m23, m33, m43,
            m14, m24, m34, m44
        )
    }
    
    public var inverse: Matrix4x4 {
        let adjugate = self.adjugate // avoid recalculating
        return adjugate * (1 / determinant(forAdjugate: adjugate))
    }
    
    public static prefix func - (m: Matrix4x4) -> Matrix4x4 {
        return m.inverse
    }
    
    public static func *(lhs: Matrix4x4, rhs: Matrix4x4) -> Matrix4x4 {
        var m = Matrix4x4.identity
        
        m.m11 = lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12
        m.m11 += lhs.m31 * rhs.m13 + lhs.m41 * rhs.m14
        
        m.m12 = lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12
        m.m12 += lhs.m32 * rhs.m13 + lhs.m42 * rhs.m14
        
        m.m13 = lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12
        m.m13 += lhs.m33 * rhs.m13 + lhs.m43 * rhs.m14
        
        m.m14 = lhs.m14 * rhs.m11 + lhs.m24 * rhs.m12
        m.m14 += lhs.m34 * rhs.m13 + lhs.m44 * rhs.m14
        
        m.m21 = lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22
        m.m21 += lhs.m31 * rhs.m23 + lhs.m41 * rhs.m24
        
        m.m22 = lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22
        m.m22 += lhs.m32 * rhs.m23 + lhs.m42 * rhs.m24
        
        m.m23 = lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22
        m.m23 += lhs.m33 * rhs.m23 + lhs.m43 * rhs.m24
        
        m.m24 = lhs.m14 * rhs.m21 + lhs.m24 * rhs.m22
        m.m24 += lhs.m34 * rhs.m23 + lhs.m44 * rhs.m24
        
        m.m31 = lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32
        m.m31 += lhs.m31 * rhs.m33 + lhs.m41 * rhs.m34
        
        m.m32 = lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32
        m.m32 += lhs.m32 * rhs.m33 + lhs.m42 * rhs.m34
        
        m.m33 = lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32
        m.m33 += lhs.m33 * rhs.m33 + lhs.m43 * rhs.m34
        
        m.m34 = lhs.m14 * rhs.m31 + lhs.m24 * rhs.m32
        m.m34 += lhs.m34 * rhs.m33 + lhs.m44 * rhs.m34
        
        m.m41 = lhs.m11 * rhs.m41 + lhs.m21 * rhs.m42
        m.m41 += lhs.m31 * rhs.m43 + lhs.m41 * rhs.m44
        
        m.m42 = lhs.m12 * rhs.m41 + lhs.m22 * rhs.m42
        m.m42 += lhs.m32 * rhs.m43 + lhs.m42 * rhs.m44
        
        m.m43 = lhs.m13 * rhs.m41 + lhs.m23 * rhs.m42
        m.m43 += lhs.m33 * rhs.m43 + lhs.m43 * rhs.m44
        
        m.m44 = lhs.m14 * rhs.m41 + lhs.m24 * rhs.m42
        m.m44 += lhs.m34 * rhs.m43 + lhs.m44 * rhs.m44
        
        return m
    }
    
    public static func *(lhs: Matrix4x4, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }
    
    public static func *(lhs: Matrix4x4, rhs: Vector4) -> Vector4 {
        return rhs * lhs
    }
    
    public static func *(lhs: Matrix4x4, rhs: Scalar) -> Matrix4x4 {
        return Matrix4x4(
            lhs.m11 * rhs, lhs.m12 * rhs, lhs.m13 * rhs, lhs.m14 * rhs,
            lhs.m21 * rhs, lhs.m22 * rhs, lhs.m23 * rhs, lhs.m24 * rhs,
            lhs.m31 * rhs, lhs.m32 * rhs, lhs.m33 * rhs, lhs.m34 * rhs,
            lhs.m41 * rhs, lhs.m42 * rhs, lhs.m43 * rhs, lhs.m44 * rhs
        )
    }
    
    public static func ==(lhs: Matrix4x4, rhs: Matrix4x4) -> Bool {
        if !lhs.m11.isEqual(to: rhs.m11) { return false }
        if !lhs.m12.isEqual(to: rhs.m12) { return false }
        if !lhs.m13.isEqual(to: rhs.m13) { return false }
        if !lhs.m14.isEqual(to: rhs.m14) { return false }
        if !lhs.m21.isEqual(to: rhs.m21) { return false }
        if !lhs.m22.isEqual(to: rhs.m22) { return false }
        if !lhs.m23.isEqual(to: rhs.m23) { return false }
        if !lhs.m24.isEqual(to: rhs.m24) { return false }
        if !lhs.m31.isEqual(to: rhs.m31) { return false }
        if !lhs.m32.isEqual(to: rhs.m32) { return false }
        if !lhs.m33.isEqual(to: rhs.m33) { return false }
        if !lhs.m34.isEqual(to: rhs.m34) { return false }
        if !lhs.m41.isEqual(to: rhs.m41) { return false }
        if !lhs.m42.isEqual(to: rhs.m42) { return false }
        if !lhs.m43.isEqual(to: rhs.m43) { return false }
        if !lhs.m44.isEqual(to: rhs.m44) { return false }
        return true
    }
    
    public static func !=(lhs: Matrix4x4, rhs: Matrix4x4) -> Bool {
        if lhs.m11.isEqual(to: rhs.m11) { return false }
        if lhs.m12.isEqual(to: rhs.m12) { return false }
        if lhs.m13.isEqual(to: rhs.m13) { return false }
        if lhs.m14.isEqual(to: rhs.m14) { return false }
        if lhs.m21.isEqual(to: rhs.m21) { return false }
        if lhs.m22.isEqual(to: rhs.m22) { return false }
        if lhs.m23.isEqual(to: rhs.m23) { return false }
        if lhs.m24.isEqual(to: rhs.m24) { return false }
        if lhs.m31.isEqual(to: rhs.m31) { return false }
        if lhs.m32.isEqual(to: rhs.m32) { return false }
        if lhs.m33.isEqual(to: rhs.m33) { return false }
        if lhs.m34.isEqual(to: rhs.m34) { return false }
        if lhs.m41.isEqual(to: rhs.m41) { return false }
        if lhs.m42.isEqual(to: rhs.m42) { return false }
        if lhs.m43.isEqual(to: rhs.m43) { return false }
        if lhs.m44.isEqual(to: rhs.m44) { return false }
        return true
    }
}
