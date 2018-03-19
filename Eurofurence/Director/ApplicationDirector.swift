//
//  ApplicationDirector.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class ApplicationDirector: RootModuleDelegate,
                           TutorialModuleDelegate,
                           PreloadModuleDelegate,
                           NewsModuleDelegate,
                           MessagesModuleDelegate,
                           LoginModuleDelegate,
                           KnowledgeListModuleDelegate,
                           KnowledgeDetailModuleDelegate {

    private class DissolveTransitionAnimationProviding: NSObject, UINavigationControllerDelegate {

        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return ViewControllerDissolveTransitioning()
        }

    }

    private let animate: Bool
    private let linkLookupService: LinkLookupService
    private let webModuleProviding: WebModuleProviding
    private let windowWireframe: WindowWireframe
    private let rootModuleProviding: RootModuleProviding
    private let tutorialModuleProviding: TutorialModuleProviding
    private let preloadModuleProviding: PreloadModuleProviding
    private let tabModuleProviding: TabModuleProviding
    private let newsModuleProviding: NewsModuleProviding
    private let messagesModuleProviding: MessagesModuleProviding
    private let loginModuleProviding: LoginModuleProviding
    private let messageDetailModuleProviding: MessageDetailModuleProviding
    private let knowledgeListModuleProviding: KnowledgeListModuleProviding
    private let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding

    private let rootNavigationController: UINavigationController
    private let rootNavigationControllerDelegate = DissolveTransitionAnimationProviding()

    private var tabController: UIViewController?
    private var newsController: UIViewController?
    private let newsNavigationController: UINavigationController
    private let knowledgeNavigationController: UINavigationController

    init(animate: Bool,
         linkLookupService: LinkLookupService,
         webModuleProviding: WebModuleProviding,
         windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleProviding: RootModuleProviding,
         tutorialModuleProviding: TutorialModuleProviding,
         preloadModuleProviding: PreloadModuleProviding,
         tabModuleProviding: TabModuleProviding,
         newsModuleProviding: NewsModuleProviding,
         messagesModuleProviding: MessagesModuleProviding,
         loginModuleProviding: LoginModuleProviding,
         messageDetailModuleProviding: MessageDetailModuleProviding,
         knowledgeListModuleProviding: KnowledgeListModuleProviding,
         knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding) {
        self.animate = animate
        self.linkLookupService = linkLookupService
        self.webModuleProviding = webModuleProviding
        self.windowWireframe = windowWireframe
        self.rootModuleProviding = rootModuleProviding
        self.tutorialModuleProviding = tutorialModuleProviding
        self.preloadModuleProviding = preloadModuleProviding
        self.tabModuleProviding = tabModuleProviding
        self.newsModuleProviding = newsModuleProviding
        self.messagesModuleProviding = messagesModuleProviding
        self.loginModuleProviding = loginModuleProviding
        self.messageDetailModuleProviding = messageDetailModuleProviding
        self.knowledgeListModuleProviding = knowledgeListModuleProviding
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding

        rootNavigationController = navigationControllerFactory.makeNavigationController()
        rootNavigationController.delegate = rootNavigationControllerDelegate
        rootNavigationController.isNavigationBarHidden = true
        windowWireframe.setRoot(rootNavigationController)

        newsNavigationController = navigationControllerFactory.makeNavigationController()
        knowledgeNavigationController = navigationControllerFactory.makeNavigationController()

        rootModuleProviding.makeRootModule(self)
    }

    // MARK: RootModuleDelegate

    func rootModuleDidDetermineTutorialShouldBePresented() {
        showTutorial()
    }

    func rootModuleDidDetermineStoreShouldRefresh() {
        showPreloadModule()
    }

    func rootModuleDidDetermineRootModuleShouldBePresented() {

    }

    // MARK: TutorialModuleDelegate

    func tutorialModuleDidFinishPresentingTutorial() {
        showPreloadModule()
    }

    // MARK: PreloadModuleDelegate

    func preloadModuleDidCancelPreloading() {
        showTutorial()
    }

    func preloadModuleDidFinishPreloading() {
        let newsController = newsModuleProviding.makeNewsModule(self)
        self.newsController = newsController

        let knowledgeListController = knowledgeListModuleProviding.makeKnowledgeListModule(self)
        knowledgeNavigationController.setViewControllers([knowledgeListController], animated: animate)

        newsNavigationController.setViewControllers([newsController], animated: animate)
        let tabModule = tabModuleProviding.makeTabModule([newsNavigationController, knowledgeNavigationController])
        tabController = tabModule

        rootNavigationController.setViewControllers([tabModule], animated: animate)
    }

    // MARK: NewsModuleDelegate

    func newsModuleDidRequestLogin() {
        newsNavigationController.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: animate)
    }

    func newsModuleDidRequestShowingPrivateMessages() {
        newsNavigationController.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: animate)
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = loginModuleProviding.makeLoginModule(self)
        loginModule.modalPresentationStyle = .formSheet

        let navigationController = UINavigationController(rootViewController: loginModule)
        tabController?.present(navigationController, animated: animate)
    }

    func messagesModuleDidRequestPresentation(for message: Message) {
        let viewController = messageDetailModuleProviding.makeMessageDetailModule(message: message)
        newsNavigationController.pushViewController(viewController, animated: animate)
    }

    func messagesModuleDidRequestDismissal() {
        guard let controller = newsController else { return }

        newsNavigationController.popToViewController(controller, animated: animate)
        tabController?.dismiss(animated: animate)
    }

    // MARK: LoginModuleDelegate

    func loginModuleDidCancelLogin() {
        messagesModuleResolutionHandler?(false)
    }

    func loginModuleDidLoginSuccessfully() {
        messagesModuleResolutionHandler?(true)
        tabController?.dismiss(animated: animate)
    }

    // MARK: KnowledgeListModuleDelegate

    func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntry2) {
        let knowledgeDetailModule = knowledgeDetailModuleProviding.makeKnowledgeListModule(knowledgeEntry, delegate: self)
        knowledgeNavigationController.pushViewController(knowledgeDetailModule, animated: animate)
    }

    // MARK: KnowledgeDetailModuleDelegate

    func knowledgeDetailModuleDidSelectLink(_ link: Link) {
        if let action = linkLookupService.lookupContent(for: link), case .web(let url) = action {
            let webModule = webModuleProviding.makeWebModule(for: url)
            tabController?.present(webModule, animated: animate)
        }
    }

    // MARK: Private

    private func showPreloadModule() {
        let preloadViewController = preloadModuleProviding.makePreloadModule(self)
        rootNavigationController.setViewControllers([preloadViewController], animated: animate)
    }

    private func showTutorial() {
        let tutorialViewController = tutorialModuleProviding.makeTutorialModule(self)
        rootNavigationController.setViewControllers([tutorialViewController], animated: animate)
    }

}
