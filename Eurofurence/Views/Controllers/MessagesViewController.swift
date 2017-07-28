//
//  MessagesViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol MessagesViewControllerDelegate: class {

    func messagesViewControllerDidRequestDismissal(_ messagesController: MessagesViewController)

}

class MessagesTableViewDataSource: NSObject, UITableViewDataSource {

    private var messages: [Message] = []

    func updateWith(messages: [Message]) {
        self.messages = messages
    }

    func message(for indexPath: IndexPath) -> Message {
        return messages[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageTableViewCell else {
            fatalError("Message cell not wired up in Storyboard")
        }

        let message = self.message(for: indexPath)
        cell.show(message: message)
        return cell
    }

}

class MessagesViewController: UIViewController,
                              UITableViewDelegate,
                              AuthenticationStateObserver,
                              LoginViewControllerDelegate,
                              PrivateMessagesObserver {

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties

    weak var messagesDelegate: MessagesViewControllerDelegate?

    private let app = EurofurenceApplication.shared
    private lazy var refreshControl = UIRefreshControl()
    private lazy var dataSource = MessagesTableViewDataSource()
    private var isLoggedIn = false
    private var didShowLogin = false

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self,
                                 action: #selector(instigateMessagesReload),
                                 for: .valueChanged)

        tableView.addSubview(refreshControl)
        tableView.dataSource = dataSource
        tableView.delegate = self
        app.add(authenticationStateObserver: self)
        app.add(privateMessagesObserver: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if !(isLoggedIn || didShowLogin) {
            didShowLogin = true
            performSegue(withIdentifier: "showTutorial", sender: self)
        } else {
            instigateMessagesReload()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "showMessage":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let destinationViewController = segue.destination as? MessageDetailViewController else { return }
            tableView.deselectRow(at: indexPath, animated: true)
            let message = dataSource.message(for: indexPath)
            destinationViewController.message = message
            app.markMessageAsRead(message)

        default:
            if let destination = segue.destination as? UINavigationController,
                let login = destination.topViewController as? LoginViewController {
                login.loginDelegate = self
            }
        }
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessage", sender: self)
    }

    // MARK: AuthenticationStateObserver

    func loggedIn(as user: User) {
        isLoggedIn = true
    }

    // MARK: LoginViewControllerDelegate

    func loginViewControllerDidLoginSuccessfully(_ loginController: LoginViewController) {
        dismiss(animated: true) {
            self.instigateMessagesReload()
        }
    }

    func loginViewControllerDidCancel(_ loginController: LoginViewController) {
        dismiss(animated: true) {
            self.messagesDelegate?.messagesViewControllerDidRequestDismissal(self)
        }
    }

    // MARK: PrivateMessagesObserver

    func privateMessagesAvailable(_ privateMessages: [Message]) {
        refreshControl.endRefreshing()
        dataSource.updateWith(messages: privateMessages)
        tableView.reloadData()
    }

    func failedToLoadPrivateMessages() {
        refreshControl.endRefreshing()
    }

    func userNotAuthenticatedForPrivateMessages() {

    }

    // MARK: Functions

    @objc func instigateMessagesReload() {
        app.fetchPrivateMessages()
    }

}
