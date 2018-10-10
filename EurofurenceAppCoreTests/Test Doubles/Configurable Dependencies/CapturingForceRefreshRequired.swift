//
//  CapturingForceRefreshRequired.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingForceRefreshRequired: ForceRefreshRequired {
    
    private(set) var wasEnquiredWhetherForceRefreshRequired = false
    var isForceRefreshRequired: Bool {
        wasEnquiredWhetherForceRefreshRequired = true
        return true
    }
    
}