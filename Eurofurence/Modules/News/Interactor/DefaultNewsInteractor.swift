//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol NewsViewModelComponent {

    var childCount: Int { get }
    var title: String { get }

    func announceContent(at index: Int, to visitor: NewsViewModelVisitor)
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void)

}

class DefaultNewsInteractor: NewsInteractor {

    private let announcementsService: AnnouncementsService
    private let authenticationService: AuthenticationService

    convenience init() {
        self.init(announcementsService: EurofurenceApplication.shared,
                  authenticationService: ApplicationAuthenticationService.shared)
    }

    init(announcementsService: AnnouncementsService, authenticationService: AuthenticationService) {
        self.announcementsService = announcementsService
        self.authenticationService = authenticationService
    }

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        makeUserWidgetViewModel { (userWidget) in
            self.announcementsService.fetchAnnouncements { (announcements) in
                let userWidget = UserComponent(viewModel: userWidget)
                let announcementsComponents = AnnouncementsComponent(announcements: announcements)
                let viewModel = ViewModel(components: [userWidget, announcementsComponents])
                delegate.viewModelDidUpdate(viewModel)
            }
        }
    }

    private func makeUserWidgetViewModel(_ completionHandler: @escaping (UserWidgetComponentViewModel) -> Void) {
        authenticationService.determineAuthState { (state) in
            let userWidget: UserWidgetComponentViewModel
            switch state {
            case .loggedIn(let user):
                userWidget = UserWidgetComponentViewModel(prompt: .welcomePrompt(for: user),
                                                          detailedPrompt: .welcomeDescription(messageCount: 0),
                                                          hasUnreadMessages: false)

            case .loggedOut:
                userWidget = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                          detailedPrompt: .anonymousUserLoginDescription,
                                                          hasUnreadMessages: false)
            }

            completionHandler(userWidget)
        }
    }

    private struct UserComponent: NewsViewModelComponent {

        private let viewModel: UserWidgetComponentViewModel

        init(viewModel: UserWidgetComponentViewModel) {
            self.viewModel = viewModel
        }

        var childCount: Int { return 1 }
        var title: String { return .yourEurofurence }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            completionHandler(.messages)
        }

    }

    private struct AnnouncementsComponent: NewsViewModelComponent {

        private let announcements: [Announcement2]
        private let viewModels: [AnnouncementComponentViewModel]

        init(announcements: [Announcement2]) {
            self.announcements = announcements
            viewModels = announcements.map({ (announcement) -> AnnouncementComponentViewModel in
                return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
            })
        }

        var childCount: Int { return viewModels.count }
        var title: String { return .announcements }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            let viewModel = viewModels[index]
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            let announcement = announcements[index]
            completionHandler(.announcement(announcement))
        }

    }

    private struct ViewModel: NewsViewModel {

        private let components: [NewsViewModelComponent]

        init(components: [NewsViewModelComponent]) {
            self.components = components
        }

        var numberOfComponents: Int {
            return components.count
        }

        func numberOfItemsInComponent(at index: Int) -> Int {
            return components[index].childCount
        }

        func titleForComponent(at index: Int) -> String {
            return components[index].title
        }

        func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
            let component = components[indexPath.section]
            component.announceContent(at: indexPath.item, to: visitor)
        }

        func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
            components[indexPath.section].announceValue(at: indexPath.item, to: completionHandler)
        }

    }

}
