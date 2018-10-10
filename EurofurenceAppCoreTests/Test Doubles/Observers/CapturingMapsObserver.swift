//
//  CapturingMapsObserver.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingMapsObserver: MapsObserver {
    
    private(set) var capturedMaps: [Map2] = []
    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        capturedMaps = maps
    }
    
}