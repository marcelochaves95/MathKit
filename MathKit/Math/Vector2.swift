//
//  Vector2.swift
//  MathKit
//
//  Created by Marcelo Chaves on 04/05/19.
//  Copyright © 2019 Marcelo Chaves. All rights reserved.
//

import Foundation

public struct Vector2 {
    public var x: Scalar
    public var y: Scalar
}

extension Vector2: Hashable {
    public var hashValue: Int {
        return x.hashValue &+ y.hashValue
    }
}

public extension Vector2 {
    public static let zero = Vector2(0, 0)
    public static let x = Vector2(1, 0)
    public static let y = Vector2(0, 1)
    
    public var lengthSquared: Scalar {
        return x * x + y * y
    }
    
    public var length: Scalar {
        return sqrt(lengthSquared)
    }
    
    public var inverse: Vector2 {
        return -self
    }
    
    public init(_ x: Scalar, _ y: Scalar) {
        self.init(x: x, y: y)
    }
    
    public init(_ v: [Scalar]) {
        assert(v.count == 2, "array must contain 2 elements, contained \(v.count)")
        self.init(v[0], v[1])
    }
    
    public func toArray() -> [Scalar] {
        return [x, y]
    }
    
    public func dot(_ v: Vector2) -> Scalar {
        return x * v.x + y * v.y
    }
    
    public func cross(_ v: Vector2) -> Scalar {
        return x * v.y - y * v.x
    }
    
    public func normalized() -> Vector2 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    public func rotated(by radians: Scalar) -> Vector2 {
        let cs = cos(radians)
        let sn = sin(radians)
        return Vector2(x * cs - y * sn, x * sn + y * cs)
    }
    
    public func rotated(by radians: Scalar, around pivot: Vector2) -> Vector2 {
        return (self - pivot).rotated(by: radians) + pivot
    }
    
    public func angle(with v: Vector2) -> Scalar {
        if self == v {
            return 0
        }
        
        let t1 = normalized()
        let t2 = v.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1, min(1, t1.dot(t2)))
        
        return atan2(cross, dot)
    }
    
    public func interpolated(with v: Vector2, by t: Scalar) -> Vector2 {
        return self + (v - self) * t
    }
    
    public static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    public static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    public static prefix func - (v: Vector2) -> Vector2 {
        return Vector2(-v.x, -v.y)
    }
    
    public static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x * rhs.x, lhs.y * rhs.y)
    }
    
    public static func * (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.x * rhs, lhs.y * rhs)
    }
    
    public static func * (lhs: Vector2, rhs: Matrix3x3) -> Vector2 {
        return Vector2(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + rhs.m31,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + rhs.m32
        )
    }
    
    public static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x / rhs.x, lhs.y / rhs.y)
    }
    
    public static func / (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.x / rhs, lhs.y / rhs)
    }
    
    public static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x.isEqual(to: lhs.x) && lhs.y.isEqual(to: rhs.y)
    }
    
    public static func != (lhs: Vector2, rhs: Vector2) -> Bool {
        return !lhs.x.isEqual(to: rhs.x) && !lhs.y.isEqual(to: rhs.y)
    }
}
