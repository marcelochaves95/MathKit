# MathKit

MathKit is a Swift library for iOS and macOS that implements common 2D and 3D vector and matrix functions, useful for games or vector-based graphics.

MathKit takes advantage of Swift language features such as function and operator overloading and struct methods to provide a more elegant interface than most C, C++ or Cocoa-based graphics APIs.

MathKit also provides a  handy replacement for the GLKit vector math types and functions, which are not available yet in Swift due to their reliance on union types.

MathKit is a completely standalone library, relying only on the Foundation framework. However, it provides optional compatibility extensions for SceneKit and Quartz (CoreGraphics/CoreAnimation) for interoperability with UIKit, AppKit, SpriteKit and SceneKit.

MathKit is designed to be efficient, but has not been heavily optimized yet, and does not yet take advantage of architecture-specific hardware acceleration using the Accelerate framework.

Types
--------------

MathKit declares the following types:

```swift
Scalar
```

This is a typealias used for the scalar floating point values in the VectorMath library. It is set to Float by default, but you can change it to Double or CGFloat to improve performance for your specific application.

```swift
Vector2
Vector3
Vector4
```

These represent 2D, 3D and 4D vectors, respectively.

```swift
Matrix3x3
Matrix4x4
```

These represent homogenous 3x3 and 4x4 transform matrices, respectively.

```swift
Quaternion
```

This represents a rotation in 3D space. It has the same structure as Vector4D, but is defined as a different type due to the different use cases and methods.
 
All the VectorMath types conform to Equatable and Hashable, so they can be stored in Swift dictionaries.


Constants
-------------

VectorMath declares a number of namespaced constants for your convenience. They are as follows:

```swift
Scalar.pi
Scalar.halfPi
Scalar.quarterPi
Scalar.twoPi
```

These should be self-explanatory.

```swift
Scalar.degreesPerRadian
Scalar.radiansPerDegree
```

Conversion factors between degrees and radians. E.g. to convert 40 degrees to radians, you would say `let r = 40 * .degreesPerRadian`, or to convert Pi/2 radians to degrees, say `let d = .halfPi * .radiansPerDegree`

```swift
Scalar.epsilon = 0.0001
```

This is a floating point error value used by the approx-equal operator. You can change this if it's insufficiently (or excessively) precise for your needs.

```swift
Vector2.zero
Vector3.zero
Vector4.zero
Quaternion.Zero
```

These are zero vector constants, useful as default values for vectors

```swift
Vector2.x
Vector2.y
Vector3.x
Vector3.y
Vector3.z
Vector4.x
Vector4.y
Vector4.z
Vector4.w
```

These are unit vectors along various axes. For example Vector3.z has the value `Vector3(0, 0, 1)`

```swift
Matrix3x3.identity
Matrix4x3.identity
Quaternion.identity
```

These are identity matrices, which have the property that multiplying them by another matrix or vector has no effect.


Methods
------------

The complete list of VectorMath properties and methods is given below. These are mostly self-explanatory. If you can't find a method you are looking for (e.g. a method to rotate a vector using a quaternion), it's probably implemented as an operator (see "Operators" below).

```swift
Vector2
    init(x: Scalar, y: Scalar)
    init(_: Scalar, _: Scalar)
    init(_: [Scalar])
    lengthSquared: Scalar
    length: Scalar
    inverse: Vector2
    toArray() -> [Scalar]
    dot(Vector2) -> Scalar
    cross(Vector2) -> Scalar
    normalized() -> Vector2
    rotated(by: Scalar) -> Vector2
    rotated(by: Scalar, around: Vector2) -> Vector2
    angle(with: Vector2) -> Scalar
    interpolated(with: Vector2, by: Scalar) -> Vector2

Vector3
    init(x: Scalar, y: Scalar, z: Scalar)
    init(_: Scalar, _: Scalar, _: Scalar)
    init(_: [Scalar])
    lengthSquared: Scalar
    length: Scalar
    inverse: Vector3
    xy: Vector2
    xz: Vector2
    yz: Vector2
    toArray() -> [Scalar]
    dot(Vector3) -> Scalar
    cross(Vector3) -> Vector3
    normalized() -> Vector3
    interpolated(with: Vector3, by: Scalar) -> Vector3

Vector4
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar)
    init(_: Scalar, _: Scalar, _: Scalar, _: Scalar)
    init(_: Vector3, w: Scalar)
    init(_: [Scalar])
    lengthSquared: Scalar
    length: Scalar
    inverse: Vector4
    xyz: Vector3
    xy: Vector2
    xz: Vector2
    yz: Vector2
    toArray() -> [Scalar]
    toVector3() -> Vector3
    dot(Vector4) -> Scalar
    normalized() -> Vector4
    interpolated(with: Vector4, by: Scalar) -> Vector4

Matrix3x3
    init(m11: Scalar, m12: Scalar, ... m33: Scalar)
    init(_: Scalar, _: Scalar, ... _: Scalar)
    init(scale: Vector2)
    init(translation: Vector2)
    init(rotation: Scalar)
    init(_: [Scalar])
    adjugate: Matrix3
    determinant: Scalar
    transpose: Matrix3
    inverse: Matrix3
    toArray() -> [Scalar]
    interpolated(with: Matrix3, by: Scalar) -> Matrix3

Matrix4x4
    init(m11: Scalar, m12: Scalar, ... m33: Scalar)
    init(_: Scalar, _: Scalar, ... _: Scalar)
    init(scale: Vector3)
    init(translation: Vector3)
    init(rotation: Vector4)
    init(quaternion: Quaternion)
    init(fovx: Scalar, fovy: Scalar, near: Scalar, far: Scalar)
    init(fovx: Scalar, aspect: Scalar, near: Scalar, far: Scalar)
    init(fovy: Scalar, aspect: Scalar, near: Scalar, far: Scalar)
    init(top: Scalar, right: Scalar, bottom: Scalar, left: Scalar, near: Scalar, far: Scalar)
    init(_: [Scalar])
    adjugate: Matrix4
    determinant: Scalar
    transpose: Matrix4
    inverse: Matrix4
    toArray() -> [Scalar]
    interpolated(with: Matrix3, by: Scalar) -> Matrix3

Quaternion
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar)
    init(_: Scalar, _: Scalar, _: Scalar, _: Scalar)
    init(axisAngle: Vector4)
    init(pitch: Scalar, yaw: Scalar, roll: Scalar)
    init(rotationMatrix m: Matrix4)
    init(_: [Scalar])
    lengthSquared: Scalar
    length: Scalar
    inverse: Quaternion
    xyz: Vector3
    pitch: Scalar
    yaw: Scalar
    roll: Scalar
    toAxisAngle() -> Vector4
    toPitchYawRoll() -> (pitch: Scalar, yaw: Scalar, roll: Scalar)
    toArray() -> [Scalar]
    dot(Quaternion) -> Scalar
    normalized() -> Quaternion
    interpolated(with: Quaternion, by: Scalar) -> Quaternion
```

Operators
------------

The *, /, +, - and == operators are implemented for most of the included types. * in particular is useful for matrix and vector transforms. For example, to apply a matrix transform "m" to a vector "v" you can write `m * v`. * can also be used in conjunction with a Scalar value to scale a vector.

Unary minus is supported for inversion/negation on vectors and matrices.

Dot product, cross product and normalization are not available in operator form, but are supplied as methods on the various types.

## Implementations
- - [x] Matrix3x3
- - [x] Matrix4x4
- - [x] Quaternion
- - [x] Scalar
- - [x] Vector2
- - [x] Vector3
- - [x] Vector4
- - [x] MapKit
- - [x] Quartz
- - [x] SceneKit
- - [ ] Unit Tests

## License
MIT license. See the [`LICENSE`](LICENSE) file for details.
