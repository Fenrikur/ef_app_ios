//
//  AnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol AnnouncementsService {

    func add(_ observer: AnnouncementsServiceObserver)

}

protocol AnnouncementsServiceObserver {

    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2])
    func eurofurenceApplicationDidChangeUnreadAnnouncements(to announcements: [Announcement2])

}
