//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingNavigationController: UINavigationController {
    
    private(set) var pushedViewControllers = [UIViewController]()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    private(set) var viewControllerPoppedTo: UIViewController?
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        viewControllerPoppedTo = viewController
        return super.popToViewController(viewController, animated: animated)
    }
    
}

struct StubNavigationControllerFactory: NavigationControllerFactory {
    
    func makeNavigationController() -> UINavigationController {
        return CapturingNavigationController()
    }
    
}

class StubRootModuleFactory: RootModuleFactory {
    
    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }
    
}

class StubTutorialModuleFactory: TutorialModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubPreloadModuleFactory: PreloadModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubNewsModuleFactory: NewsModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: NewsModuleDelegate?
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubMessagesModuleFactory: MessagesModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: MessagesModuleDelegate?
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class FakeViewController: UIViewController {
    
    private(set) var capturedPresentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}

class StubTabModuleFactory: TabModuleFactory {
    
    let stubInterface = FakeViewController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        capturedTabModules = childModules
        return stubInterface
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return capturedTabModules
                .flatMap({ $0 as? CapturingNavigationController })
                .first(where: { $0.topViewController === viewController })
    }
    
}

class StubLoginModuleFactory: LoginModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: LoginModuleDelegate?
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class CapturingWindowWireframe: WindowWireframe {
    
    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }
    
}

class ApplicationDirectorTests: XCTestCase {
    
    var director: ApplicationDirector!
    var rootModuleFactory: StubRootModuleFactory!
    var tutorialModuleFactory: StubTutorialModuleFactory!
    var preloadModuleFactory: StubPreloadModuleFactory!
    var tabModuleFactory: StubTabModuleFactory!
    var newsModuleFactory: StubNewsModuleFactory!
    var messagesModuleFactory: StubMessagesModuleFactory!
    var loginModuleFactory: StubLoginModuleFactory!
    var windowWireframe: CapturingWindowWireframe!
    
    private func navigateToTabController() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
    }
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModuleFactory = StubTabModuleFactory()
        newsModuleFactory = StubNewsModuleFactory()
        messagesModuleFactory = StubMessagesModuleFactory()
        loginModuleFactory = StubLoginModuleFactory()
        director = ApplicationDirector(windowWireframe: windowWireframe,
                                       navigationControllerFactory: StubNavigationControllerFactory(),
                                       rootModuleFactory: rootModuleFactory,
                                       tutorialModuleFactory: tutorialModuleFactory,
                                       preloadModuleFactory: preloadModuleFactory,
                                       tabModuleFactory: tabModuleFactory,
                                       newsModuleFactory: newsModuleFactory,
                                       messagesModuleFactory: messagesModuleFactory,
                                       loginModuleFactory: loginModuleFactory)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidCancelPreloading()
        
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        XCTAssertEqual(tabModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenShowingTheTheTabModuleItIsInitialisedWithControllersForTabModulesNestedInNavigationControllers() {
        navigateToTabController()
        let expected: [UIViewController] = [newsModuleFactory.stubInterface]
        let actual = tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController }).flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenTheNewsModuleRequestsLoginTheMessagesControllerIsPushedOntoItsNavigationController() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestLogin()
        
        XCTAssertEqual(messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheNewsModuleRequestsShowingPrivateMessagesTheMessagesControllerIsPushedOntoItsNavigationController() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        
        XCTAssertEqual(messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalItIsPoppedOffTheStack() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestDismissal()
        
        XCTAssertEqual(newsModuleFactory.stubInterface, newsNavigationController?.viewControllerPoppedTo)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedOnTopOfTheTabController() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        
        XCTAssertEqual(tabModuleFactory.stubInterface.capturedPresentedViewController, loginModuleFactory.stubInterface)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedUsingTheFormSheetModalPresentationStyle() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        
        XCTAssertEqual(loginModuleFactory.stubInterface.modalPresentationStyle, .formSheet)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleCancelsLoginTheMessagesModuleIsToldResolutionFailed() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        loginModuleFactory.delegate?.loginModuleDidCancelLogin()
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionFailedBeforeLoginIsCancelled() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        
        XCTAssertTrue(userResolved)
    }
    
}
