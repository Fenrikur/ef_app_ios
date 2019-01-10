//
//  WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould: XCTestCase {

    func testChangeToNilConDay() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(.distantPast).with(dataStore).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)

        XCTAssertTrue(delegate.toldChangedToNilDay)
    }

    func testRestrictEventsToTheFirstConferenceDay() {
        let response = APISyncResponse.randomWithoutDeletions
        let firstDay = response.conferenceDays.changed.sorted(by: { $0.date < $1.date }).first!
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(response)
        let imageRepository = CapturingImageRepository()
        imageRepository.stubEverything(response)
        let context = ApplicationTestBuilder().with(dataStore).with(.distantPast).with(imageRepository).build()
        let schedule = context.eventsService.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })
        let expected = context.makeExpectedEvents(from: expectedEvents, response: response)

        XCTAssertEqual(expected, delegate.events)
    }

}
