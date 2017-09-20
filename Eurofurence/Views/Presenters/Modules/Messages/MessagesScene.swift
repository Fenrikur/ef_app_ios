//
//  MessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol MessagesSceneDelegate {

    func messagesSceneDidSelectMessage(at indexPath: IndexPath)

}

protocol MessagesScene: class {

    var delegate: MessagesSceneDelegate? { get set }

    func showRefreshIndicator()
    func hideRefreshIndicator()

    func bindMessages(with binder: MessageItemBinder)
    func showMessages(_ viewModel: MessagesViewModel)

    func showMessagesList()
    func hideMessagesList()

    func showNoMessagesPlaceholder()
    func hideNoMessagesPlaceholder()

}

protocol MessageItemBinder {

    func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath)

}

protocol MessageItemScene {

    func presentAuthor(_ author: String)
    func presentSubject(_ subject: String)
    func presentContents(_ contents: String)

}

struct MessagesViewModel: Equatable {

    // MARK: Properties

    private var viewModels: [MessageViewModel]

    var numberOfMessages: Int {
        return viewModels.count
    }

    // MARK: Initialization

    init(messages: [Message]) {
        self.viewModels = messages.map(MessageViewModel.init)
    }

    init(childViewModels: [MessageViewModel]) {
        viewModels = childViewModels
    }

    // MARK: Functions

    func messageViewModel(at index: Int) -> MessageViewModel {
        return viewModels[index]
    }

    // MARK: Equatable

    static func ==(lhs: MessagesViewModel, rhs: MessagesViewModel) -> Bool {
        return lhs.viewModels == rhs.viewModels
    }

}

struct MessageViewModel: Equatable {

    // MARK: Properties

    var author: String
    var formattedReceivedDate: String
    var subject: String
    var message: String
    var isRead: Bool

    // MARK: Initialization

    init(message: Message) {
        self.author = message.authorName
        self.formattedReceivedDate = ""
        self.subject = ""
        self.message = ""
        self.isRead = false
    }

    init(author: String, formattedReceivedDate: String, subject: String, message: String, isRead: Bool) {
        self.author = author
        self.formattedReceivedDate = formattedReceivedDate
        self.subject = subject
        self.isRead = isRead
        self.message = message
    }

    // MARK: Equatable

    static func ==(lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
        return  lhs.author == rhs.author &&
                lhs.formattedReceivedDate == rhs.formattedReceivedDate &&
                lhs.subject == rhs.subject &&
                lhs.message == rhs.message &&
                lhs.isRead == rhs.isRead
    }

}
