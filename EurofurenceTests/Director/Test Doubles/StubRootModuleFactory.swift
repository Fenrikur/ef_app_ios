//
//  StubRootModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class StubRootModuleFactory: RootModuleProviding {
    
    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }
    
}

extension StubRootModuleFactory {
    
    func simulateTutorialShouldBePresented() {
        delegate?.rootModuleDidDetermineTutorialShouldBePresented()
    }
    
    func simulateStoreShouldBeRefreshed() {
        delegate?.rootModuleDidDetermineStoreShouldRefresh()
    }
    
}