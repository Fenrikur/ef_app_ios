//
//  WhenDealerDetailSceneLoads_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {
    
    func testTellTheInteractorToMakeViewModelUsingDealerIdentifier() {
        let identifier: Dealer2.Identifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(identifier, context.interactor.capturedIdentifierForProducingViewModel)
    }
    
}
