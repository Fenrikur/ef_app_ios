//
//  WhenUserSelectsKnowledgeEntry_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenUserSelectsKnowledgeEntry_DirectorShould: XCTestCase {
    
    func testShowTheKnowledgeEntryModuleForTheChosenEntry() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeEntrySelected(entry)
        
        XCTAssertEqual(context.knowledgeDetailModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, context.knowledgeDetailModule.capturedModel)
    }
    
}