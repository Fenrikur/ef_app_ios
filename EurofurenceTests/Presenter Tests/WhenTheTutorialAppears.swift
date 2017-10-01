//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubTutorialSceneFactory: TutorialSceneFactory {
    
    let tutorialScene = CapturingTutorialScene()
    func makeTutorialScene() -> TutorialScene {
        return tutorialScene
    }
    
}

class WhenTheTutorialAppears: XCTestCase {

    struct TutorialTestContext {
        var tutorialSceneFactory: StubTutorialSceneFactory
        var wireframe: CapturingPresentationWireframe
        var tutorial: CapturingTutorialScene
        var page: CapturingTutorialPageScene
        var strings: PresentationStrings
        var assets: PresentationAssets
        var splashRouter: CapturingSplashScreenRouter
        var alertRouter: CapturingAlertRouter
        var tutorialStateProviding: StubFirstTimeLaunchStateProvider
        var pushRequesting: CapturingPushPermissionsRequesting
    }

    private func showTutorial(_ networkReachability: NetworkReachability = ReachableWiFiNetwork(),
                              _ pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()) -> TutorialTestContext {
        let alertRouter = CapturingAlertRouter()
        let splashRouter = CapturingSplashScreenRouter()
        let stateProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let pushRequesting = CapturingPushPermissionsRequesting()
        let presentationStrings = StubPresentationStrings()
        let presentationAssets = StubPresentationAssets()
        let tutorialSceneFactory = StubTutorialSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let module = TutorialModule(tutorialSceneFactory: tutorialSceneFactory,
                                    presentationStrings: presentationStrings,
                                    presentationAssets: presentationAssets,
                                    splashScreenRouter: splashRouter,
                                    alertRouter: alertRouter,
                                    tutorialStateProviding: stateProviding,
                                    networkReachability: networkReachability,
                                    pushPermissionsRequesting: pushRequesting,
                                    witnessedTutorialPushPermissionsRequest: pushPermissionsRequestStateProviding)
        module.attach(to: wireframe)

        return TutorialTestContext(tutorialSceneFactory: tutorialSceneFactory,
                                   wireframe: wireframe,
                                   tutorial: tutorialSceneFactory.tutorialScene,
                                   page: tutorialSceneFactory.tutorialScene.tutorialPage,
                                   strings: presentationStrings,
                                   assets: presentationAssets,
                                   splashRouter: splashRouter,
                                   alertRouter: alertRouter,
                                   tutorialStateProviding: stateProviding,
                                   pushRequesting: pushRequesting)
    }
    
    private func showRequestPushPermissionsTutorialPage() -> TutorialTestContext {
        return showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
    }
    
    private func showBeginInitialDownloadTutorialPage(_ networkReachability: NetworkReachability = ReachableWiFiNetwork()) -> TutorialTestContext {
        let setup = showTutorial(networkReachability, UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        return setup
    }
    
    func testSetTheTutorialSceneAsTheRootOntoTheWireframe() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorialSceneFactory.tutorialScene === setup.wireframe.capturedRootScene)
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }
    
    // MARK: Request push permissions page
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsTitleOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.strings[.tutorialPushPermissionsRequestTitle],
                       setup.page.capturedPageTitle)
    }
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsDescriptionOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.strings[.tutorialPushPermissionsRequestDescription],
                       setup.page.capturedPageDescription)
    }
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsImageOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.assets.requestPushNotificationPermissionsAsset,
                       setup.page.capturedPageImage)
    }

    func testShowingThePushPermissionsRequestPageShouldShowThePrimaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }

    func testShowingThePushPermissionsRequestPageShouldSetTheAllowPushPermissionsStringOntoThePrimaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()

        XCTAssertEqual(setup.strings[.tutorialAllowPushPermissions],
                       setup.page.capturedPrimaryActionDescription)
    }

    func testShowingThePushPermissionsRequestPageShouldShowTheSecondaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertTrue(setup.page.didShowSecondaryActionButton)
    }

    func testShowingThePushPermissionsRequestPageShouldSetTheDenyPushPermissionsStringOntoTheSecondaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertEqual(setup.strings[.tutorialDenyPushPermissions],
                       setup.page.capturedSecondaryActionDescription)
    }

    func testShowingPushPermissionsRequestPageThenTappingSecondaryButtonShouldShowNewPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()

        XCTAssertEqual(2, setup.tutorial.numberOfPagesShown)
    }

    func testShowingPushPermissionsRequestPageThenTappingSecondaryButtonShouldNotShowNewPageUntilButtonIsActuallyTapped() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertEqual(1, setup.tutorial.numberOfPagesShown)
    }

    func testShowingPushPermissionsRequestPageThenTappingPrimaryButtonShouldRequestPushPermissions() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.pushRequesting.didRequestPermission)
    }

    func testShowingPushPermissionsRequestPageShouldNotImmediatleyRequestPushPermissions() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertFalse(setup.pushRequesting.didRequestPermission)
    }

    func testTappingPrimaryButtonWhenRequestingPushPermissionsWithWifiShouldNotShowSplashScreen() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingPrimaryButtonWhenRequestingPushPermissionsWithoutWifiShouldNotShowAlert() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testRequestingPushPermissionsFinishesShouldShowNewPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()
        setup.pushRequesting.completeRegistrationRequest()

        XCTAssertEqual(2, setup.tutorial.numberOfPagesShown)
    }

    func testRequestingPushPermissionsFinishesShouldMarkUserAsAcknowledgingPushPermissions() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()
        setup.pushRequesting.completeRegistrationRequest()

        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    func testUserShouldNotBeMarkedAsAcknowledgingPushPermissionsUntilRequestCompletes() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    func testDenyingPushPermissionsShouldMarkUserAsAcknowledgingPushPermissions() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()

        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    // MARK: Prepare for initial download page

    func testItShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings[.tutorialInitialLoadTitle],
                       setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings[.tutorialInitialLoadDescription],
                       setup.page.capturedPageDescription)
    }

    func testItShouldShowTheInformationImageForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.assets.initialLoadInformationAsset,
                       setup.page.capturedPageImage)
    }
    
    func testItShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        let setup = showBeginInitialDownloadTutorialPage()
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        let setup = showBeginInitialDownloadTutorialPage()
        
        XCTAssertEqual(setup.strings[.tutorialInitialLoadBeginDownload],
                       setup.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonOnTheInitiateDownloadPageShouldNotRequestPushPermissions() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.pushRequesting.didRequestPermission)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsSplashRouterToShowTheSplashScreen() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.splashRouter.wasToldToShowSplashScreen)
    }
    
    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsTutorialCompletionProvidingToMarkTutorialAsComplete() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        
        XCTAssertTrue(setup.tutorialStateProviding.didMarkTutorialAsComplete)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlert() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableShouldNotTellSplashScreenRouterToShowTheSplashScreen() {
        let setup = showBeginInitialDownloadTutorialPage(UnreachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableDoesNotTellAlertRouterToShowAlert() {
        let setup = showBeginInitialDownloadTutorialPage(ReachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings[.cellularDownloadAlertTitle],
                       setup.alertRouter.presentedAlertTitle)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings[.cellularDownloadAlertMessage],
                       setup.alertRouter.presentedAlertMessage)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.first

        XCTAssertEqual(setup.strings[.cellularDownloadAlertContinueOverCellularTitle],
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithCancelAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.last

        XCTAssertEqual(setup.strings[.cancel], action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldTellTheSplashRouterToShowTheSplashScreen() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(setup.splashRouter.wasToldToShowSplashScreen)
    }
    
    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldMarkTheTutorialAsComplete() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()
        
        XCTAssertTrue(setup.tutorialStateProviding.didMarkTutorialAsComplete)
    }

}
