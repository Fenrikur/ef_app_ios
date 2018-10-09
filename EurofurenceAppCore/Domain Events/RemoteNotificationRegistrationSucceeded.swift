//
//  RemoteNotificationRegistrationSucceeded.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension DomainEvent {

    struct RemoteNotificationRegistrationSucceeded {
        var deviceToken: Data
    }

}