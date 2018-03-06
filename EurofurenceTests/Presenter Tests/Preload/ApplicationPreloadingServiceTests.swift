//
//  ApplicationPreloadingServiceTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationPreloadingServiceTests: XCTestCase {
    
    func testPreloadingTellsAppToRefreshLocalStore() {
        let app = CapturingEurofurenceApplication()
        let service = ApplicationPreloadingService(app: app)
        let delegate = CapturingPreloadServiceDelegate()
        service.beginPreloading(delegate: delegate)
        
        XCTAssertTrue(app.wasToldToRefreshLocalStore)
    }
    
    func testFailedRefreshesTellDelegatePreloadServiceFailed() {
        let app = CapturingEurofurenceApplication()
        let service = ApplicationPreloadingService(app: app)
        let delegate = CapturingPreloadServiceDelegate()
        service.beginPreloading(delegate: delegate)
        app.failLastRefresh()
        
        XCTAssertTrue(delegate.wasToldPreloadServiceDidFail)
    }
    
    func testSuccessfulRefreshesDoNotTellDelegatePreloadServiceSucceeded() {
        let app = CapturingEurofurenceApplication()
        let service = ApplicationPreloadingService(app: app)
        let delegate = CapturingPreloadServiceDelegate()
        service.beginPreloading(delegate: delegate)
        app.succeedLastRefresh()
        
        XCTAssertFalse(delegate.wasToldPreloadServiceDidFail)
    }
    
}
