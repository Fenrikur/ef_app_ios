//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct SchedulePresenter: ScheduleSceneDelegate, ScheduleInteractorDelegate {

    private struct Binder: ScheduleSceneBinder {

        var viewModel: ScheduleViewModel

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModel.eventGroups[index]
            header.setEventGroupTitle(group.title)
        }

    }

    private let scene: ScheduleScene
    private let interactor: ScheduleInteractor

    init(scene: ScheduleScene, interactor: ScheduleInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setDelegate(self)
    }

    func scheduleSceneDidLoad() {
        interactor.setDelegate(self)
    }

    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel) {
        let numberOfItemsPerGroup = viewModel.eventGroups.map { $0.events.count }
        let binder = Binder(viewModel: viewModel)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
