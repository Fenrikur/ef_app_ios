//
//  WhenSceneSelectsDealer_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSceneSelectsDealer_DealersPresenterShould: XCTestCase {
    
    func testTellTheModuleDelegateTheDealerIdentifierForTheIndexPathWasSelected() {
        let viewModel = CapturingDealersViewModel()
        let identifier = Dealer2.Identifier.random
        let indexPath = IndexPath.random
        viewModel.stub(identifier, forDealerAt: indexPath)
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectDealer(at: indexPath)
        
        XCTAssertEqual(identifier, context.delegate.capturedSelectedDealerIdentifier)
    }
    
}