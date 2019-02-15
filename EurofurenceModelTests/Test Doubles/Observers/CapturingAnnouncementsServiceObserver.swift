//
//  CapturingAnnouncementsServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingAnnouncementsServiceObserver: AnnouncementsServiceObserver {

    private(set) var allAnnouncements: [AnnouncementProtocol] = []
    private(set) var didReceieveEmptyAllAnnouncements = false
    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [AnnouncementProtocol]) {
        allAnnouncements = announcements
        didReceieveEmptyAllAnnouncements = didReceieveEmptyAllAnnouncements || announcements.isEmpty
    }

    private(set) var didReceieveEmptyReadAnnouncements = false
    private(set) var readAnnouncementIdentifiers = [AnnouncementIdentifier]()
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        didReceieveEmptyReadAnnouncements = didReceieveEmptyReadAnnouncements || readAnnouncements.isEmpty
        readAnnouncementIdentifiers = readAnnouncements
    }

}
