//
//  KnowledgeEntry2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeEntry2: Comparable, Equatable, Hashable {

    var title: String
    var order: Int

    var hashValue: Int {
        return title.hashValue ^ order.hashValue
    }

    static func ==(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.title == rhs.title && lhs.order == rhs.order
    }

    static func <(lhs: KnowledgeEntry2, rhs: KnowledgeEntry2) -> Bool {
        return lhs.order < rhs.order
    }

}