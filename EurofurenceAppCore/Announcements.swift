//
//  Announcements.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Announcements {

    // MARK: Properties

    private let dataStore: EurofurenceDataStore
    private let imageRepository: ImageRepository
    private var readAnnouncementIdentifiers = [Announcement2.Identifier]()

    var models = [Announcement2]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: EurofurenceDataStore, imageRepository: ImageRepository) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadAnnouncementsFromStore))

        reloadAnnouncementsFromStore()
        readAnnouncementIdentifiers = dataStore.getSavedReadAnnouncementIdentifiers().or([])
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }

    func openAnnouncement(identifier: Announcement2.Identifier, completionHandler: @escaping (Announcement2) -> Void) {
        guard let model = models.first(where: { $0.identifier == identifier }) else { return }
        completionHandler(model)

        readAnnouncementIdentifiers.append(identifier)
        announcementsObservers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers) })

        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(self.readAnnouncementIdentifiers)
        }
    }

    func fetchAnnouncementImage(identifier: Announcement2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        let announcement = dataStore.getSavedAnnouncements()?.first(where: { $0.identifier == identifier.rawValue })
        let imageData: Data? = announcement.let { (announcement) in
            let entity: ImageEntity? = announcement.imageIdentifier.let(imageRepository.loadImage)
            return entity?.pngImageData
        }

        completionHandler(imageData)
    }

    // MARK: Private

    private func reloadAnnouncementsFromStore() {
        guard let announcements = dataStore.getSavedAnnouncements() else { return }
        models = announcements.sorted(by: isLastEditTimeAscending).map(Announcement2.init)
    }

    private func isLastEditTimeAscending(_ first: APIAnnouncement, _ second: APIAnnouncement) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeAnnouncements(models)
        observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
    }

}