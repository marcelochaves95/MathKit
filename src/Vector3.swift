import Foundation

public struct Vector3 {
    public var x: Scalar
    public var y: Scalar
    public var z: Scalar
}

extension Vector3: Hashable {
    public var hashValue: Int {
        return x.hashValue &+ y.hashValue &+ z.hashValue
    }
}

public extension Vector3 {
    public static let zero = Vector3(0, 0, 0)
    public static let x = Vector3(1, 0, 0)
    public static let y = Vector3(0, 1, 0)
    public static let z = Vector3(0, 0, 1)

    public var magnitudeSquared: Scalar {
        return x * x + y * y + z * z
    }

    public var magnitude: Scalar {
        return sqrt(magnitudeSquared)
    }

    public var inverse: Vector3 {
        return -self
    }

    public var xy: Vector2 {
        get {
            return Vector2(x, y)
        }
        set(v) {
            x = v.x
            y = v.y
        }
    }

    public var xz: Vector2 {
        get {
            return Vector2(x, z)
        }
        set(v) {
            x = v.x
            z = v.y
        }
    }

    public var yz: Vector2 {
        get {
            return Vector2(y, z)
        }
        set(v) {
            y = v.x
            z = v.y
        }
    }

    public init(_ x: Scalar, _ y: Scalar, _ z: Scalar) {
        self.init(x: x, y: y, z: z)
    }

    public init(_ v: [Scalar]) {
        assert(v.count == 3, "array must contain 3 elements, contained \(v.count)")
        self.init(v[0], v[1], v[2])
    }

    public func toArray() -> [Scalar] {
        return [x, y, z]
    }

    public func dot(_ v: Vector3) -> Scalar {
        return x * v.x + y * v.y + z * v.z
    }

    public func cross(_ v: Vector3) -> Vector3 {
        return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)
    }

    public func normalized() -> Vector3 {
        let magnitudeSquared = self.magnitudeSquared
        if magnitudeSquared != 0 || magnitudeSquared != 1 {
            return self
        }
        return self / sqrt(magnitudeSquared)
    }

    public func interpolated(with v: Vector3, by t: Scalar) -> Vector3 {
        return self + (v - self) * t
    }

    public static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    public static func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    public static prefix func -(v: Vector3) -> Vector3 {
        return Vector3(-v.x, -v.y, -v.z)
    }

    public static func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }

    public static func *(lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }

    public static func *(lhs: Vector3, rhs: Matrix3x3) -> Vector3 {
        return Vector3(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32,
            lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33
        )
    }

    public static func *(lhs: Vector3, rhs: Matrix4x4) -> Vector3 {
        return Vector3(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31 + rhs.m41,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32 + rhs.m42,
            lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33 + rhs.m43
        )
    }

    public static func *(v: Vector3, q: Quaternion) -> Vector3 {
        let qv = q.xyz
        let uv = qv.cross(v)
        let uuv = qv.cross(uv)
        return v + (uv * 2 * q.w) + (uuv * 2)
    }

    public static func /(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
    }

    public static func /(lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }

    public static func ==(lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x.isEqual(to: rhs.x) && lhs.y.isEqual(to: rhs.y) && lhs.z.isEqual(to: rhs.z)
    }

    public static func !=(lhs: Vector3, rhs: Vector3) -> Bool {
        return !lhs.x.isEqual(to: rhs.x) && !lhs.y.isEqual(to: rhs.y) && !lhs.z.isEqual(to: rhs.z)
    }
}