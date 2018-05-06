//
//  AnnouncementDetailInteractorFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol AnnouncementDetailInteractorFactory {

    func makeAnnouncementDetailInteractor(for announcement: Announcement2) -> AnnouncementDetailInteractor

}
