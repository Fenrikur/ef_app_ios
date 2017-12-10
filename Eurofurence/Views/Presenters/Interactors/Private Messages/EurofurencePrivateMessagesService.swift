//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class EurofurencePrivateMessagesService: PrivateMessagesService {

    static var shared = EurofurencePrivateMessagesService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol
    private var unreadMessageCountObservers = [PrivateMessageUnreadCountObserver]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    var unreadMessageCount: Int {
        return app.localPrivateMessages.filter(isUnread).count
    }

    var localMessages: [Message] {
        return app.localPrivateMessages
    }

    func add(_ unreadMessageCountObserver: PrivateMessageUnreadCountObserver) {
        unreadMessageCountObservers.append(unreadMessageCountObserver)
        provideUnreadMessageCount(to: unreadMessageCountObserver)
    }

    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) {
        app.fetchPrivateMessages { (result) in
            switch result {
            case .success(let messages):
                completionHandler(.success(messages))
                self.unreadMessageCountObservers.forEach(self.provideUnreadMessageCount)

            default:
                completionHandler(.failure)
            }
        }
    }

    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }

    private func provideUnreadMessageCount(to unreadMessageCountObserver: PrivateMessageUnreadCountObserver) {
        unreadMessageCountObserver.unreadPrivateMessagesCountDidChange(to: unreadMessageCount)
    }

}
