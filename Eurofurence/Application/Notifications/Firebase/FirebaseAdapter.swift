//
//  FirebaseAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum FirebaseTopic: CustomStringConvertible, Hashable {

    case test
    case testAll
    case live
    case liveAll
    case ios
    case debug
    case version(String)

    static func ==(lhs: FirebaseTopic, rhs: FirebaseTopic) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var hashValue: Int {
        return description.hashValue
    }

    var description: String {
        switch self {
        case .test:
            return "test"
        case .testAll:
            return "test-all"
        case .live:
            return "live"
        case .liveAll:
            return "live-all"
        case .ios:
            return "ios"
        case .debug:
            return "debug"
        case .version(let version):
            return "Version-\(version)"
        }
    }

}

protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data)
    func subscribe(toTopic topic: FirebaseTopic)
    func unsubscribe(fromTopic topic: FirebaseTopic)

}
