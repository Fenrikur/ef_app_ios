//
//  WhenAddingAnnouncementsObserverAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAddingAnnouncementsObserverAfterSuccessfulRefresh: XCTestCase {
    
    func testTheAnnouncementsFromTheRefreshResponseAreAdaptedInLastChangedTimeOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedAnnouncements(from: syncResponse)
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertEqual(expected, observer.unreadAnnouncements)
    }
    
}