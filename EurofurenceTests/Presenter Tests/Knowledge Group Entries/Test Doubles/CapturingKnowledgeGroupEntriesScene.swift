//
//  CapturingKnowledgeGroupEntriesScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingKnowledgeGroupEntriesScene: KnowledgeGroupEntriesScene {
    
    fileprivate var delegate: KnowledgeGroupEntriesSceneDelegate?
    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedNumberOfEntriesToBind: Int?
    private(set) var binder: KnowledgeGroupEntriesBinder?
    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder) {
        capturedNumberOfEntriesToBind = numberOfEntries
        self.binder = binder
    }
    
}

extension CapturingKnowledgeGroupEntriesScene {
    
    func simulateSceneDidLoad() {
        delegate?.knowledgeGroupEntriesSceneDidLoad()
    }
    
    func simulateSceneDidSelectEntry(at index: Int) {
        delegate?.knowledgeGroupEntriesSceneDidSelectEntry(at: index)
    }
    
}
