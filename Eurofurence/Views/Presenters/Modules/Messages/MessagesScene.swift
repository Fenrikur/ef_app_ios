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

    func showMessagesList()
    func hideMessagesList()

    func showNoMessagesPlaceholder()
    func hideNoMessagesPlaceholder()

}

protocol MessageItemBinder {

    var numberOfMessages: Int { get }

    func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath)

}

protocol MessageItemScene {

    func presentAuthor(_ author: String)
    func presentSubject(_ subject: String)
    func presentContents(_ contents: String)
    func presentReceivedDateTime(_ dateTime: String)

}
