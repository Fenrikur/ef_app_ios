//
//  APIDealer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIDealer: Equatable {

    var identifier: String
    var displayName: String
    var attendeeNickname: String
    var attendsOnThursday: Bool
    var attendsOnFriday: Bool
    var attendsOnSaturday: Bool
    var isAfterDark: Bool
    var artistThumbnailImageId: String?

}