//
//  KnowledgeEntry2.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension KnowledgeEntry2: RandomValueProviding {
    
    public static var random: KnowledgeEntry2 {
        return KnowledgeEntry2(identifier: .random, title: .random, order: .random, contents: .random, links: .random)
    }
    
}

extension KnowledgeEntry2.Identifier: RandomValueProviding {
    
    public static var random: KnowledgeEntry2.Identifier {
        return KnowledgeEntry2.Identifier(.random)
    }
    
}