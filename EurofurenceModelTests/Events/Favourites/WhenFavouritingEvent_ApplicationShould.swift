//
//  WhenFavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingEvent_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var events: [EventCharacteristics]!

    override func setUp() {
        super.setUp()

        let response = ModelCharacteristics.randomWithoutDeletions
        events = response.events.changed
        let dataStore = FakeDataStore(response: response)

        context = EurofurenceSessionTestBuilder().with(dataStore).build()
    }

    func testTellTheDataStoreToSaveTheEventIdentifier() {
        let randomEvent = events.randomElement().element
        let identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()

        XCTAssertTrue([identifier].contains(elementsFrom: context.dataStore.fetchFavouriteEventIdentifiers()))
    }

    func testTellEventsObserversTheEventIsNowFavourited() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellEventObserverItIsNowFavourited() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventObserver()
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.add(observer)
        event?.favourite()

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

    func testOrganiseTheFavouritesInStartTimeOrder() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let storedFavourites = events.map({ EventIdentifier($0.identifier) })
        storedFavourites.filter({ $0 != identifier }).compactMap(context.eventsService.fetchEvent).forEach { (event) in
            event.favourite()
        }

        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

}
