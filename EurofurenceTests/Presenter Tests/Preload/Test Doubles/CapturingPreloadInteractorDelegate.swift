//
//  CapturingPreloadInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore

class CapturingPreloadInteractorDelegate: PreloadInteractorDelegate {

    private(set) var wasToldpreloadInteractorDidFailToPreload = false
    func preloadInteractorDidFailToPreload() {
        wasToldpreloadInteractorDidFailToPreload = true
    }

    private(set) var wasToldpreloadInteractorDidFinishPreloading = false
    func preloadInteractorDidFinishPreloading() {
        wasToldpreloadInteractorDidFinishPreloading = true
    }

    private(set) var capturedProgressCurrentUnitCount: Int?
    private(set) var capturedProgressTotalUnitCount: Int?
    private(set) var capturedProgressLocalizedDescription: String?
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String) {
        capturedProgressCurrentUnitCount = currentUnitCount
        capturedProgressTotalUnitCount = totalUnitCount
        capturedProgressLocalizedDescription = localizedDescription
    }

}
