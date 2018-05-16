//
//  WhenObservingUpcomingEvents_ThenLoadSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingUpcomingEvents_ThenLoadSucceeds: XCTestCase {
    
    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)
        
        XCTAssertTrue(observer.upcomingEvents.contains(expected))
    }
    
    func testTheObserverIsNotProvidedWithEventsThatHaveBegan() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = ApplicationTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return event.startDateTime > simulatedTime
        }
        
        let expected = expectedEvents.map { (event) -> Event2 in
            return context.makeExpectedEvent(from: event, response: syncResponse)
        }
        
        XCTAssertEqual(expected, observer.upcomingEvents)
    }
    
}