//
//  PrivateMessagesController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus

class PrivateMessagesController {

    private let privateMessagesAPI: PrivateMessagesAPI
    private var userAuthenticationToken: String?
    private var privateMessageObservers = [PrivateMessagesObserver]()

    private(set) var localPrivateMessages: [Message] = []

    init(eventBus: EventBus, privateMessagesAPI: PrivateMessagesAPI) {
        self.privateMessagesAPI = privateMessagesAPI
        eventBus.subscribe(userLoggedIn)
    }

    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: determineUnreadMessageCount())
        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: localPrivateMessages)
    }
    
    private func determineUnreadMessageCount() -> Int {
        return localPrivateMessages.filter({ $0.isRead == false }).count
    }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        if let token = userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { (messages) in
                if let messages = messages {
                    let messages = messages.sorted()
                    self.localPrivateMessages = messages
                    let unreadCount = self.determineUnreadMessageCount()
                    self.privateMessageObservers.forEach({ (observer) in
                        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount)
                        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: messages)
                    })
                    completionHandler(.success(messages))
                } else {
                    completionHandler(.failedToLoad)
                }
            }
        } else {
            completionHandler(.userNotAuthenticated)
        }
    }

    func markMessageAsRead(_ message: Message) {
        guard let token = userAuthenticationToken else { return }
        privateMessagesAPI.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
    }

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        userAuthenticationToken = event.authenticationToken
    }

}
