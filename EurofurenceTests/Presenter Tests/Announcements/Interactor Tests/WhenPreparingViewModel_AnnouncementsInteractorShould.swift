//
//  WhenPreparingViewModel_AnnouncementsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_AnnouncementsInteractorShould: XCTestCase {
    
    func testIndicateTheTotalNumberOfAnnouncements() {
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        
        XCTAssertEqual(announcements.count, viewModel?.numberOfAnnouncements)
    }
    
}
