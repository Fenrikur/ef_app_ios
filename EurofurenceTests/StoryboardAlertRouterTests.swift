//
//  StoryboardAlertRouterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest
import UIKit

class CapturingViewController: UIViewController {

    private(set) var capturedPresentedAlertViewController: UIAlertController?
    private(set) var animatedTransition = false
    private(set) var capturedPresentationCompletionHandler: (() -> Void)?
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        capturedPresentedAlertViewController = viewControllerToPresent as? UIAlertController
        animatedTransition = flag
        capturedPresentationCompletionHandler = completion
    }
    
    private(set) var didDismissPresentedController = false
    private(set) var didDismissUsingAnimations = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didDismissPresentedController = true
        didDismissUsingAnimations = flag
    }

}

class StoryboardAlertRouterTests: XCTestCase {

    var capturingViewController: CapturingViewController!
    var alertRouter: AlertRouter!

    override func setUp() {
        super.setUp()

        capturingViewController = CapturingViewController()
        let window = UIWindow(frame: .zero)
        window.rootViewController = capturingViewController
        alertRouter = StoryboardRouters(window: window).alertRouter
    }
    
    func testPresentingAlertShouldShowAlertControllerWithAlertStyleOntoRootViewController() {
        alertRouter.show(Alert(title: "", message: ""))
        XCTAssertEqual(capturingViewController.capturedPresentedAlertViewController?.preferredStyle, .alert)
    }

    func testPresentingAlertShouldShowAlertControllerWithAnimation() {
        alertRouter.show(Alert(title: "", message: ""))
        XCTAssertTrue(capturingViewController.animatedTransition)
    }

    func testPresentingAlertShouldSetTheTitleOntoTheAlertController() {
        let expectedTitle = "Title"
        alertRouter.show(Alert(title: expectedTitle, message: ""))

        XCTAssertEqual(expectedTitle, capturingViewController.capturedPresentedAlertViewController?.title)
    }

    func testPresentingAlertShouldSetTheMessageOntoTheAlertController() {
        let expectedMessage = "Message"
        alertRouter.show(Alert(title: "", message: expectedMessage))

        XCTAssertEqual(expectedMessage, capturingViewController.capturedPresentedAlertViewController?.message)
    }

    func testPresentingAlertWithActionShouldAddActionWithActionTitle() {
        let expectedActionTitle = "Action"
        alertRouter.show(Alert(title: "", message: "", actions: [AlertAction(title: expectedActionTitle)]))
        let firstAction = capturingViewController.capturedPresentedAlertViewController?.actions.first

        XCTAssertEqual(expectedActionTitle, firstAction?.title)
    }

    func testPresentingAlertWithMultipleActionsShouldAddActionsInTheOrderTheyAreGiven() {
        let firstActionTitle = "First action"
        let secondActionTitle = "Second action"
        alertRouter.show(Alert(title: "",
                              message: "",
                              actions: [AlertAction(title: firstActionTitle),
                                        AlertAction(title: secondActionTitle)]))

        let actions = capturingViewController.capturedPresentedAlertViewController?.actions

        XCTAssertEqual(firstActionTitle, actions?.first?.title)
        XCTAssertEqual(secondActionTitle, actions?.last?.title)
    }
    
    func testWhenPresentationCompletesTheHandlerIsInvoked() {
        var alert = Alert(title: "", message: "")
        var invoked = false
        alert.onCompletedPresentation = { _ in invoked = true }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        
        XCTAssertTrue(invoked)
    }
    
    func testPresentationCompletedHandleNotInvokedUntilCompletionHandlerRan() {
        var alert = Alert(title: "", message: "")
        var invoked = false
        alert.onCompletedPresentation = { _ in invoked = true }
        alertRouter.show(alert)
        
        XCTAssertFalse(invoked)
    }
    
    func testDismissingDismissableTellsRootControllerToDismissPresentedController() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        dismissable?.dismiss()
        
        XCTAssertTrue(capturingViewController.didDismissPresentedController)
    }
    
    func testRootControllerDoesNotInvokeDismissalUntilToldTo() {
        var alert = Alert(title: "", message: "")
        alert.onCompletedPresentation = { _ in }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        
        XCTAssertFalse(capturingViewController.didDismissPresentedController)
    }
    
    func testDismissingAlertsUseAnimations() {
        var alert = Alert(title: "", message: "")
        var dismissable: AlertDismissable?
        alert.onCompletedPresentation = { dismissable = $0 }
        alertRouter.show(alert)
        capturingViewController.capturedPresentationCompletionHandler?()
        dismissable?.dismiss()
        
        XCTAssertTrue(capturingViewController.didDismissUsingAnimations)
    }
    
}
