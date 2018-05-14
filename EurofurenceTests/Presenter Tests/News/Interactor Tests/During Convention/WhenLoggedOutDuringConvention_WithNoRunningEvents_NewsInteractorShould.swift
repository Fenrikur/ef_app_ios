//
//  WhenLoggedOutDuringConvention_WithNoRunningEvents_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggedOutDuringConvention_WithNoRunningEvents_NewsInteractorShould: XCTestCase {
    
    func testProduceViewModelWithMessagesPrompt_Announcements_AndUpcomingEvents() {
        let eventsService = StubEventsService()
        let runningEvents = [Event2]()
        eventsService.runningEvents = runningEvents
        eventsService.upcomingEvents = .random
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(StubAnnouncementsService(announcements: .random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()
        
        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasAnnouncements()
            .hasUpcomingEvents()
            .verify()
    }
    
}