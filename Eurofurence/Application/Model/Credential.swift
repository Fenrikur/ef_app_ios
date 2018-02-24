//
//  Credential.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct Credential: Equatable {

    var username: String
    var registrationNumber: Int
    var authenticationToken: String
    var tokenExpiryDate: Date

    static func ==(lhs: Credential, rhs: Credential) -> Bool {
        return lhs.username == rhs.username &&
               lhs.registrationNumber == rhs.registrationNumber &&
               lhs.authenticationToken == rhs.authenticationToken &&
               lhs.tokenExpiryDate == rhs.tokenExpiryDate
    }

    func isValid(currentDate: Date) -> Bool {
        return currentDate < tokenExpiryDate
    }

}