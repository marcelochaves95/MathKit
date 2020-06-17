//
//  MathKit+MapKit.swift
//  MathKit
//
//  Created by Marcelo Chaves on 07/05/19.
//  Copyright © 2019 Marcelo Chaves. All rights reserved.
//

#if canImport(MapKit)

import MapKit

// MARK: MapKit extensions

public extension MKMapPoint {
    init(_ v: Vector2) {
        self.init(x: Double(v.x), y: Double(v.y))
    }
}

public extension MKMapSize {
    init(_ v: Vector2) {
        self.init(width: Double(v.x), height: Double(v.y))
    }
}

// MARK: MathKit extensions

public extension Vector2 {
    init(_ v: MKMapPoint) {
        self.init(x: Scalar(v.x), y: Scalar(v.y))
    }
    
    init(_ v: MKMapSize) {
        self.init(x: Scalar(v.width), y: Scalar(v.height))
    }
}

#endif
