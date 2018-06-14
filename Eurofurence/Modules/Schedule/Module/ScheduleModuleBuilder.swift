//
//  ScheduleModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class ScheduleModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory
    private var interactor: ScheduleInteractor

    init() {
        eventsSceneFactory = StoryboardScheduleSceneFactory()
        interactor = DefaultScheduleInteractor()
    }

    @discardableResult
    func with(_ eventsSceneFactory: ScheduleSceneFactory) -> ScheduleModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: ScheduleInteractor) -> ScheduleModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> ScheduleModuleProviding {
        return ScheduleModule(eventsSceneFactory: eventsSceneFactory, interactor: interactor)
    }

}