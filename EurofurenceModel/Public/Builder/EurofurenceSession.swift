//
//  EurofurenceSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public enum EurofurenceDataStoreState {
    case absent
    case stale
    case available
}

public protocol EurofurenceSession: ApplicationNotificationHandling,
                                                RefreshService,
                                                AnnouncementsService,
                                                AuthenticationService,
                                                EventsService,
                                                DealersService,
                                                KnowledgeService,
                                                LinkLookupService,
                                                ConventionCountdownService,
                                                CollectThemAllService,
                                                MapsService {

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)

    var localPrivateMessages: [Message] { get }

    func storeRemoteNotificationsToken(_ deviceToken: Data)
    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void)
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)

    func add(_ observer: PrivateMessagesObserver)
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void)
    func markMessageAsRead(_ message: Message)

}