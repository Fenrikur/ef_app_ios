//
//  WhenFetchingMapContents_TappingWithinRadiusOfMultipleEntries_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingMapContents_TappingWithinRadiusOfMultipleEntries_ApplicationShould: XCTestCase {

    func testReturnTheClosestMatch() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let anotherCloseEntry = APIMap.Entry(identifier: .random, x: entry.x + 5, y: entry.y + 5, tapRadius: entry.tapRadius, links: .random)
        map.entries = [anotherCloseEntry, entry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.performSuccessfulSync(response: syncResponse)

        var content: Map.Content?
        context.application.fetchContent(for: Map.Identifier(map.identifier), atX: x, y: y) { content = $0 }
        let expected = Map.Content.room(Room(name: room.name))

        XCTAssertEqual(expected, content)
    }

}
