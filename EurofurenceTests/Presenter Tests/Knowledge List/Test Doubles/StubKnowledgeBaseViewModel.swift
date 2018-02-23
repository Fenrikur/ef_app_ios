//
//  StubKnowledgeListViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence
import UIKit.UIImage

extension KnowledgeListViewModel {
    
    static func withRandomData() -> KnowledgeListViewModel {
        var groups = [KnowledgeGroupViewModel]()
        let groupCount = Int(arc4random_uniform(10)) + 1
        for _ in 0..<groupCount {
            groups.append(.withRandomData())
        }
        
        return KnowledgeListViewModel(knowledgeGroups: groups)
    }
    
    var randomKnowledgeGroup: (index: Int, knowledgeGroup: KnowledgeGroupViewModel) {
        let randomGroupIndex = Int(arc4random_uniform(UInt32(knowledgeGroups.count)))
        return (index: randomGroupIndex, knowledgeGroup: knowledgeGroups[randomGroupIndex])
    }
    
}

extension KnowledgeGroupViewModel {
    
    static func withRandomData() -> KnowledgeGroupViewModel {
        var entries = [KnowledgeEntryViewModel]()
        let entryCount = Int(arc4random_uniform(10)) + 1
        for _ in 0..<entryCount {
            entries.append(.withRandomData())
        }
        
        return KnowledgeGroupViewModel(title: "\(arc4random())",
                                       icon: UIImage(),
                                       groupDescription: "\(arc4random())",
                                       knowledgeEntries: entries)
    }
    
    var randomEntry: (index: Int, knowledgeEntry: KnowledgeEntryViewModel) {
        let randomEntryIndex = Int(arc4random_uniform(UInt32(knowledgeEntries.count)))
        return (index: randomEntryIndex, knowledgeEntry: knowledgeEntries[randomEntryIndex])
    }
    
}

extension KnowledgeEntryViewModel {
    
    static func withRandomData() -> KnowledgeEntryViewModel {
        return KnowledgeEntryViewModel(title: "\(arc4random())")
    }
    
}
