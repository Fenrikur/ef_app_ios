//
//  WhenFetchingAnnouncementsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingAnnouncementsAfterSuccessfulRefresh: XCTestCase {
    
    func testTheAnnouncementsFromTheRefreshResponseAreAdaptedInLastChangedTimeOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expectedOrder = syncResponse.announcements.changed.sorted { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
        }
        
        let expected = Announcement2.fromServerModels(expectedOrder)
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expectedKnowledgeGroupsExpectation = expectation(description: "Expected announcements to be extracted from sync response")
        context.application.fetchAnnouncements { (announcements) in
            if expected == announcements {
                expectedKnowledgeGroupsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}