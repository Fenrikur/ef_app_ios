//
//  BootstrappingPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BootstrappingPresenter {

    init(context: ApplicationContext, routers: Routers) {
        if context.firstTimeLaunchProviding.userHasCompletedTutorial {
            routers.splashScreenRouter.showSplashScreen()
        } else {
            TutorialModule.initialize(context: context, routers: routers)
        }
    }

}
