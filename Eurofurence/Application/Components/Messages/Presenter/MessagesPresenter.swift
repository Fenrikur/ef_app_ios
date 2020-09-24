import EurofurenceModel
import Foundation.NSIndexPath

class MessagesPresenter: MessagesSceneDelegate, PrivateMessagesObserver {

    // MARK: Properties

    private weak var scene: MessagesScene?
    private let authenticationService: AuthenticationService
    private let privateMessagesService: PrivateMessagesService
    private let dateFormatter: DateFormatterProtocol
    private let delegate: MessagesComponentDelegate
    private var presentedMessages = [Message]()

    // MARK: Initialization

    init(scene: MessagesScene,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService,
         dateFormatter: DateFormatterProtocol,
         delegate: MessagesComponentDelegate) {
        self.scene = scene
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService
        self.dateFormatter = dateFormatter
        self.delegate = delegate

        scene.delegate = self
        scene.setMessagesTitle(.messages)
    }

    // MARK: MessagesSceneDelegate

    func messagesSceneReady() {
        privateMessagesService.add(self)
        reloadPrivateMessages()
    }
    
    func messagesSceneFinalizing() {
        privateMessagesService.removeObserver(self)
    }

    func messagesSceneDidSelectMessage(at indexPath: IndexPath) {
        let message = presentedMessages[indexPath[1]]
        delegate.messagesModuleDidRequestPresentation(for: message.identifier)
    }

    func messagesSceneDidPerformRefreshAction() {
        reloadPrivateMessages()
    }

    func messagesSceneDidTapLogoutButton() {
        delegate.showLogoutAlert { [weak self] (dismissAlert) in
            self?.authenticationService.logout { (result) in
                dismissAlert()

                switch result {
                case .success:
                    self?.delegate.messagesModuleDidRequestDismissal()

                case .failure:
                    self?.delegate.showLogoutFailedAlert()
                }
            }
        }
    }

    // MARK: PrivateMessagesServiceObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {

    }

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message]) {
        scene?.hideRefreshIndicator()
        presentMessages(messages)
    }

    func privateMessagesServiceDidFailToLoadMessages() {
        scene?.hideRefreshIndicator()
    }

    // MARK: Private

    private func userResolved(_ resolved: Bool) {
        if resolved {
            reloadPrivateMessages()
        } else {
            delegate.messagesModuleDidRequestDismissal()
        }
    }

    private func reloadPrivateMessages() {
        scene?.showRefreshIndicator()
        privateMessagesService.refreshMessages()
    }

    private func presentMessages(_ messages: [Message]) {
        presentedMessages = messages

        let binder = MessagesBinder(messages: messages, dateFormatter: dateFormatter)
        scene?.bindMessages(count: messages.count, with: binder)

        if messages.isEmpty {
            scene?.hideMessagesList()
            scene?.showNoMessagesPlaceholder()
        } else {
            scene?.showMessagesList()
            scene?.hideNoMessagesPlaceholder()
        }
    }

    private class MessagesBinder: MessageItemBinder {

        private let messages: [Message]
        private let dateFormatter: DateFormatterProtocol
        private var messageBinders = [IndexPath: MessageBinder]()
        
        init(messages: [Message], dateFormatter: DateFormatterProtocol) {
            self.messages = messages
            self.dateFormatter = dateFormatter
        }

        func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath) {
            let message = messages[indexPath[1]]
            let binder = MessageBinder(message: message, scene: scene, dateFormatter: dateFormatter)
            messageBinders[indexPath] = binder
        }

    }
    
    private struct MessageBinder: PrivateMessageObserver {
        
        private let message: Message
        private let scene: MessageItemScene
        private let dateFormatter: DateFormatterProtocol
        
        init(message: Message, scene: MessageItemScene, dateFormatter: DateFormatterProtocol) {
            self.message = message
            self.scene = scene
            self.dateFormatter = dateFormatter
            
            scene.setAuthor(message.authorName)
            scene.setSubject(message.subject)
            scene.setContents(message.contents)

            if message.isRead {
                scene.hideUnreadIndicator()
            } else {
                scene.showUnreadIndicator()
            }

            let formattedDateTime = dateFormatter.string(from: message.receivedDateTime)
            scene.setReceivedDateTime(formattedDateTime)
            
            message.add(self)
        }
        
        func messageMarkedUnread() {
            
        }
        
        func messageMarkedRead() {
            scene.hideUnreadIndicator()
        }
        
    }

}
