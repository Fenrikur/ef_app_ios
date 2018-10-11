//
//  WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould: XCTestCase {

    func testBindTheNumberOfAnnouncementsFromTheViewModelOntoTheScene() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.announcements.count, context.scene.capturedAnnouncementsToBind)
    }

}
