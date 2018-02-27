//
//  WhenPerformingSyncThatSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSyncThatSucceeds: XCTestCase {
    
    func testTheKnowledgeGroupsArePersistedIntoTheStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.random
        let expected = syncResponse.knowledgeGroups.map { (group) -> KnowledgeGroup2 in
            let entries = syncResponse.knowledgeEntries.filter({ $0.groupIdentifier == group.identifier }).map { (entry) in
                return KnowledgeEntry2(title: entry.title)
            }
            
            return KnowledgeGroup2(title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   entries: entries)
        }
        
        context.application.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(context.dataStore.didSave(expected))
    }
    
}
