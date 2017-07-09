//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheAppLaunches: XCTestCase {
    
    func testAndTheUserHasNotFinishedTheTutorialTheTutorialRouterIsToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [],
                                   routers: routers)

        XCTAssertTrue(tutorialRouter.wasToldToShowTutorial)
    }

    func testAndTheUserHasPreviouslyFinishedTheTutorialTheSplashRouterIsToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [],
                                   routers: routers)

        XCTAssertTrue(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testAndTheUserHasNotFinishedTheTutorialTheSplashScreenRouterShouldNotBeToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [],
                                   routers: routers)

        XCTAssertFalse(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testAndTheUserHasPreviouslyFinishedTheTutorialTheTutorialRouterShouldNotBeToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [],
                                   routers: routers)

        XCTAssertFalse(tutorialRouter.wasToldToShowTutorial)
    }
    
}
