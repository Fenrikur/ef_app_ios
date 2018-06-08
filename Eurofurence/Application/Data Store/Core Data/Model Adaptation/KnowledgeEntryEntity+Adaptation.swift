//
//  KnowledgeEntryEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension KnowledgeEntryEntity: EntityAdapting {

    typealias AdaptedType = APIKnowledgeEntry

    func asAdaptedType() -> APIKnowledgeEntry {
        let links = Array((self.links as? Set<LinkEntity>) ?? Set<LinkEntity>())

        return APIKnowledgeEntry(groupIdentifier: groupIdentifier!,
                                 title: title!,
                                 order: Int(order),
                                 text: text!,
                                 links: links.map({ $0.asAdaptedType() }).sorted())
    }

}
