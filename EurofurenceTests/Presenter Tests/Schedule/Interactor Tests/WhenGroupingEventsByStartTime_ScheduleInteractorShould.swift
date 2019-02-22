//
//  WhenGroupingEventsByStartTime_ScheduleInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenGroupingEventsByStartTime_ScheduleInteractorShould: XCTestCase {

    var events: [Event]!
    var eventsService: FakeEventsService!
    var context: ScheduleInteractorTestBuilder.Context!
    var expectedGroups: [ScheduleEventGroupViewModelAssertion.Group]!

    override func setUp() {
        super.setUp()

        let firstGroupDate = Date.random
        let a = StubEvent.random
        a.startDate = firstGroupDate
        let b = StubEvent.random
        b.startDate = firstGroupDate
        let c = StubEvent.random
        c.startDate = firstGroupDate
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = StubEvent.random
        d.startDate = secondGroupDate
        let e = StubEvent.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        events = firstGroupEvents + secondGroupEvents
        eventsService = FakeEventsService()

        context = ScheduleInteractorTestBuilder().with(eventsService).build()

        expectedGroups = [ScheduleEventGroupViewModelAssertion.Group(date: firstGroupDate, events: firstGroupEvents),
                          ScheduleEventGroupViewModelAssertion.Group(date: secondGroupDate, events: secondGroupEvents)]
    }

    private func simulateEventsChanged() {
        eventsService.simulateEventsChanged(events)
    }

    func testGroupEventsByStartTime() {
        simulateEventsChanged()
        context.makeViewModel()

        ScheduleEventGroupViewModelAssertion.assertionForEventViewModels(context: context)
            .assertEventGroupViewModels(context.eventsViewModels, isModeledBy: expectedGroups)
    }

    func testProvideUpdatedGroupsToDelegate() {
        context.makeViewModel()
        simulateEventsChanged()

        ScheduleEventGroupViewModelAssertion.assertionForEventViewModels(context: context)
            .assertEventGroupViewModels(context.eventsViewModels, isModeledBy: expectedGroups)
    }

    func testProvideTheExpectedIdentifier() {
        simulateEventsChanged()
        let viewModel = context.makeViewModel()

        let randomEventInGroupOne = expectedGroups[0].events.randomElement()
        let indexPath = IndexPath(item: randomEventInGroupOne.index, section: 0)
        let expected = randomEventInGroupOne.element.identifier
        let actual = viewModel?.identifierForEvent(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
