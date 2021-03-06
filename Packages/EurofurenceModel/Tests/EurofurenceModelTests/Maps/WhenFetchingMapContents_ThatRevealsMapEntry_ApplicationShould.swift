import EurofurenceModel
import XCTest

class WhenFetchingMapContents_ThatRevealsMapEntry_ApplicationShould: XCTestCase {

	func testProvideTheDealer() {
		let context = EurofurenceSessionTestBuilder().build()
		var syncResponse = ModelCharacteristics.randomWithoutDeletions
		let expectedMapEntry = MapCharacteristics.Entry(
            identifier: .random,
            x: Int.random,
            y: Int.random,
            tapRadius: Int.random,
            links: []
        )
        
		var map = MapCharacteristics.random
		let link = MapCharacteristics.Entry.Link(type: .mapEntry, name: .random, target: expectedMapEntry.identifier)
		let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
		let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
		map.entries = [entry, expectedMapEntry]
		syncResponse.maps.changed = [map]
		context.performSuccessfulSync(response: syncResponse)

		var content: MapContent?
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { content = $0 })
		let expected = MapContent.location(x: Float(expectedMapEntry.x), y: Float(expectedMapEntry.y), name: link.name)

		XCTAssertEqual(expected, content)
	}

}
