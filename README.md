# MathKit

MathKit is a Swift library for iOS and macOS that implements common 2D and 3D vector and matrix functions, useful for games or vector-based graphics.

MathKit takes advantage of Swift language features such as function and operator overloading and struct methods to provide a more elegant interface than most C, C++ or Cocoa-based graphics APIs.

MathKit also provides a  handy replacement for the GLKit vector math types and functions, which are not available yet in Swift due to their reliance on union types.

MathKit is a completely standalone library, relying only on the Foundation framework. However, it provides optional compatibility extensions for MapKit, SceneKit and Quartz (CoreGraphics/CoreAnimation) for interoperability with UIKit, AppKit, SpriteKit and SceneKit.

MathKit is designed to be efficient, but has not been heavily optimized yet, and does not yet take advantage of architecture-specific hardware acceleration using the Accelerate framework.

## Implemented:
- - [x] Matrix3x3
- - [x] Matrix4x4
- - [x] Quaternion
- - [x] Scalar
- - [x] Vector2
- - [x] Vector3
- - [x] Vector4
