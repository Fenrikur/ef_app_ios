//
//  WhenResolvingDealerAfterDarkContent_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenResolvingDealerAfterDarkContent_DealersInteractorShould: XCTestCase {
    
    func testIdentifyWhetherDealerContainsAfterDarkContentFromModel() {
        let dealer = Dealer2.random
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(dealer.isAfterDark, dealerViewModel?.isAfterDarkContentPresent)
    }
    
}