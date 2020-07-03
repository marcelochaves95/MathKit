//
//  Scalar.swift
//  MathKit
//
//  Created by Marcelo Chaves on 04/05/19.
//  Copyright © 2019 Marcelo Chaves. All rights reserved.
//

import Foundation

public typealias Scalar = Float

public extension Scalar {
    public static let halfPi = pi / 2
    public static let quarterPi = pi / 4
    public static let twoPi = pi * 2
    public static let degreesPerRadian = 180 / pi
    public static let radiansPerDegree = pi / 180
    public static let epsilon: Scalar = 0.0001
    
    public static func !=(lhs: Scalar, rhs: Scalar) -> Bool {
        return abs(lhs - rhs) < .epsilon
    }
    
    fileprivate var sign: Scalar {
        return self > 0 ? 1 : -1
    }
}
