//
//  APILink.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APILink: Equatable {

    var name: String

    static func ==(lhs: APILink, rhs: APILink) -> Bool {
        return lhs.name == rhs.name
    }

}
