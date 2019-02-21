//
//  CoreDataEurofurenceDataStoreShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import CoreData
import EurofurenceModel
import XCTest

class CoreDataEurofurenceDataStoreShould: XCTestCase {

    var storeIdentifier: String!
    var store: CoreDataEurofurenceDataStore!

    private func recreateStore() {
        store = CoreDataEurofurenceDataStore(storeName: storeIdentifier)
    }

    override func setUp() {
        super.setUp()

        storeIdentifier = .random
        recreateStore()
    }

    override func tearDown() {
        super.tearDown()

        if let url = store?.storeLocation {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error)
            }
        }
    }

    func testSaveLastRefreshDate() {
        let expected = Date.random
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(expected)
        }

        recreateStore()
        let actual = store.fetchLastRefreshDate()

        XCTAssertEqual(expected, actual)
    }

    func testUseTheLastDavedRefreshDateWhenSavingMultipleTimes() {
        let expected = Date.random
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(expected)
        }

        recreateStore()
        let actual = store.fetchLastRefreshDate()

        XCTAssertEqual(expected, actual)
    }

    func testSaveKnowledgeGroups() {
        let expected = [KnowledgeGroupCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(expected)
        }

        recreateStore()
        let actual = store.fetchKnowledgeGroups()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingKnowledgeGroupsByIdentifier() {
        var group = KnowledgeGroupCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }

        group.groupName = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }

        let savedGroups = store.fetchKnowledgeGroups()

        XCTAssertEqual(1, savedGroups?.count)
        XCTAssertEqual(group.groupName, savedGroups?.first?.groupName)
    }

    func testSaveKnowledgeEntries() {
        let expected = [KnowledgeEntryCharacteristics].random.sorted()
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries(expected)
        }

        recreateStore()
        let actual = store.fetchKnowledgeEntries()

        assertThat(expected, isEqualTo: actual?.sorted())
    }

    func testUpdateExistingKnowledgeEntriesByIdentifier() {
        var entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        entry.title = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        let savedEntries = store.fetchKnowledgeEntries()

        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(entry.title, savedEntries?.first?.title)
    }

    // TODO: This is sorta testing internals, but not sure if there's another avenue for us to assert upon
    func testNotDuplicateLinksWhenUpdatingKnowledgeEntries() {
        let entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        let link = entry.links.randomElement().element

        let linksFetchRequest: NSFetchRequest<LinkEntity> = LinkEntity.fetchRequest()
        linksFetchRequest.predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)

        store.container.viewContext.performAndWait {
            do {
                let result = try linksFetchRequest.execute()
                XCTAssertEqual(1, result.count)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testEnsureLinksDeletedFromRemoteModelAreNotReconstitutedLater_BUG() {
        var entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        let deletedLink = entry.links.randomElement()
        entry.links.remove(at: deletedLink.index)
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }

        if let entry = store.fetchKnowledgeEntries()?.first {
            XCTAssertFalse(entry.links.contains(deletedLink.element),
                           "Link deleted from remote model not deleted from local data store")
        } else {
            XCTFail("Failed to save knowledge entry into data store")
        }
    }

    func testEnsureDeletedMapEntriesAreNotReconstitutedLater_BUG() {
        var map = MapCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }

        let deletedMapEntry = map.entries.randomElement()
        map.entries.remove(at: deletedMapEntry.index)
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }

        if let map = store.fetchMaps()?.first {
            XCTAssertFalse(map.entries.contains(deletedMapEntry.element),
                           "Map entry deleted from remote model not deleted from local data store")
        } else {
            XCTFail("Failed to save knowledge entry into data store")
        }
    }

    func testSaveEvents() {
        let expected = [EventCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveEvents(expected)
        }

        recreateStore()
        let actual = store.fetchEvents()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingEventsByIdentifier() {
        var event = EventCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }

        event.title = .random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }

        let savedEntries = store.fetchEvents()

        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(event.title, savedEntries?.first?.title)
    }

    func testSaveRooms() {
        let expected = [RoomCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveRooms(expected)
        }

        recreateStore()
        let actual = store.fetchRooms()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingRoomsByIdentifier() {
        var room = RoomCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }

        room.name = .random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }

        let savedRooms = store.fetchRooms()

        XCTAssertEqual(1, savedRooms?.count)
        XCTAssertEqual(room.name, savedRooms?.first?.name)
    }

    func testSaveTracks() {
        let expected = [TrackCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveTracks(expected)
        }

        recreateStore()
        let actual = store.fetchTracks()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingTracksByIdentifier() {
        var track = TrackCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }

        track.name = .random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }

        let savedTracks = store.fetchTracks()

        XCTAssertEqual(1, savedTracks?.count)
        XCTAssertEqual(track.name, savedTracks?.first?.name)
    }

    func testSaveAnnouncements() {
        let expected = [AnnouncementCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements(expected)
        }

        recreateStore()
        let actual = store.fetchAnnouncements()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingAnnouncementsByIdentifier() {
        var announcement = AnnouncementCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }

        announcement.title = .random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }

        let savedAnnouncements = store.fetchAnnouncements()

        XCTAssertEqual(1, savedAnnouncements?.count)
        XCTAssertEqual(announcement.title, savedAnnouncements?.first?.title)
    }

    func testSaveFavouriteEventIdentifiers() {
        let exected = [EventIdentifier].random
        store.performTransaction { (transaction) in
            exected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        recreateStore()
        let actual = store.fetchFavouriteEventIdentifiers()

        assertThat(exected, isEqualTo: actual)
    }

    func testNotDuplicatedSavedFavouriteEventIdentifiers() {
        let expected = [EventIdentifier].random
        store.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        store.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        recreateStore()
        let actual = store.fetchFavouriteEventIdentifiers()

        XCTAssertEqual(expected.count, actual?.count)
    }

    func testDeleteSavedFavouriteEventIdentifiers() {
        let identifier = EventIdentifier.random
        store.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }

        store.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }

        let actual = store.fetchFavouriteEventIdentifiers()

        assertThat([], isEqualTo: actual)
    }

    func testSaveConferenceDays() {
        let conferenceDays = [ConferenceDayCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays(conferenceDays)
        }

        recreateStore()
        let actual = store.fetchConferenceDays()

        assertThat(conferenceDays, isEqualTo: actual)
    }

    func testUpdateExistingConferenceDaysByIdentifier() {
        var conferenceDay = ConferenceDayCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }

        conferenceDay.date = .random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }

        let savedConferenceDays = store.fetchConferenceDays()

        XCTAssertEqual(1, savedConferenceDays?.count)
        XCTAssertEqual(conferenceDay.date, savedConferenceDays?.first?.date)
    }

    func testSaveDealers() {
        let dealers = [DealerCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveDealers(dealers)
        }

        recreateStore()
        let actual = store.fetchDealers()

        assertThat(dealers, isEqualTo: actual)
    }

    func testUpdateExistingDealersByIdentifier() {
        var dealer = DealerCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }

        dealer.attendeeNickname = .random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }

        let savedDealers = store.fetchDealers()

        XCTAssertEqual(1, savedDealers?.count)
        XCTAssertEqual(dealer.attendeeNickname, savedDealers?.first?.attendeeNickname)
    }

    func testSaveMaps() {
        let maps = [MapCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveMaps(maps)
        }

        recreateStore()
        let actual = store.fetchMaps()

        assertThat(maps, isEqualTo: actual)
    }

    func testUpdateExistingMapsByIdentifier() {
        var map = MapCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }

        map.mapDescription = .random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }

        let savedMaps = store.fetchMaps()

        XCTAssertEqual(1, savedMaps?.count)
        XCTAssertEqual(map.mapDescription, savedMaps?.first?.mapDescription)
    }

    func testSaveReadAnnouncements() {
        let expected = [AnnouncementIdentifier].random
        store.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(expected)
        }

        recreateStore()
        let actual = store.fetchReadAnnouncementIdentifiers()

        assertThat(expected, isEqualTo: actual)
    }

    func testNotDuplicateReadAnnouncementIdentifiers() {
        let expected = [AnnouncementIdentifier].random
        store.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(expected)
        }

        store.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(expected)
        }

        let actual = store.fetchReadAnnouncementIdentifiers()

        XCTAssertEqual(expected.count, actual?.count)
    }

    func testDeleteAnnouncements() {
        let element = AnnouncementCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveAnnouncements },
                       deletionBlock: { $0.deleteAnnouncement },
                       loadingBlock: { $0.fetchAnnouncements })
    }

    func testDeleteKnowledgeGroups() {
        let element = KnowledgeGroupCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveKnowledgeGroups },
                       deletionBlock: { $0.deleteKnowledgeGroup },
                       loadingBlock: { $0.fetchKnowledgeGroups })
    }

    func testDeleteKnowledgeEntries() {
        let element = KnowledgeEntryCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveKnowledgeEntries },
                       deletionBlock: { $0.deleteKnowledgeEntry },
                       loadingBlock: { $0.fetchKnowledgeEntries })
    }

    func testDeleteEvents() {
        let element = EventCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveEvents },
                       deletionBlock: { $0.deleteEvent },
                       loadingBlock: { $0.fetchEvents })
    }

    func testDeleteTracks() {
        let element = TrackCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.trackIdentifier,
                       savingBlock: { $0.saveTracks },
                       deletionBlock: { $0.deleteTrack },
                       loadingBlock: { $0.fetchTracks })
    }

    func testDeleteRooms() {
        let element = RoomCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.roomIdentifier,
                       savingBlock: { $0.saveRooms },
                       deletionBlock: { $0.deleteRoom },
                       loadingBlock: { $0.fetchRooms })
    }

    func testDeleteConferenceDays() {
        let element = ConferenceDayCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveConferenceDays },
                       deletionBlock: { $0.deleteConferenceDay },
                       loadingBlock: { $0.fetchConferenceDays })
    }

    func testDeleteDealers() {
        let element = DealerCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveDealers },
                       deletionBlock: { $0.deleteDealer },
                       loadingBlock: { $0.fetchDealers })
    }

    func testDeleteMaps() {
        let element = MapCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveMaps },
                       deletionBlock: { $0.deleteMap },
                       loadingBlock: { $0.fetchMaps })
    }

    func testSaveImages() {
        let expected = [ImageCharacteristics].random
        store.performTransaction { (transaction) in
            transaction.saveImages(expected)
        }

        recreateStore()
        let actual = store.fetchImages()

        assertThat(expected, isEqualTo: actual)
    }

    func testUpdateExistingImagesByIdentifier() {
        var image = ImageCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveImages([image])
        }

        image.internalReference = .random
        store.performTransaction { (transaction) in
            transaction.saveImages([image])
        }

        let savedImages = store.fetchImages()

        XCTAssertEqual(1, savedImages?.count)
        XCTAssertEqual(image.internalReference, savedImages?.first?.internalReference)
    }

    func testDeleteImages() {
        let element = ImageCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveImages },
                       deletionBlock: { $0.deleteImage },
                       loadingBlock: { $0.fetchImages })
    }

    private func verifyDeletion<T>(for element: T,
                                   elementIdentifier: String,
                                   savingBlock: @escaping (DataStoreTransaction) -> ([T]) -> Void,
                                   deletionBlock: @escaping (DataStoreTransaction) -> (String) -> Void,
                                   loadingBlock: (DataStore) -> () -> [T]?,
                                   file: StaticString = #file,
                                   line: UInt = #line) where T: Equatable {
        store.performTransaction { (transaction) in
            let block = savingBlock(transaction)
            block([element])
        }

        store.performTransaction { (transaction) in
            let block = deletionBlock(transaction)
            block(elementIdentifier)
        }

        recreateStore()

        let loader = loadingBlock(store)
        let elements = loader()

        XCTAssertEqual([T](), elements, file: file, line: line)
    }

    private func assertThat<T>(_ expected: [T], isEqualTo actual: [T]?, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        guard let actual = actual else {
            XCTFail("Expected actual values, but got nil", file: file, line: line)
            return
        }

        for item in expected {
            if actual.contains(item) { continue }
            XCTFail("Did not witness item: \(item)", file: file, line: line)
        }
    }

}
