//
//  WhenBindingDealerSearchResult_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerSearchResult_DealersPresenterShould: XCTestCase {
    
    var context: DealersPresenterTestBuilder.Context!
    var dealer: StubDealerViewModel!
    var component: CapturingDealerComponent!
    
    override func setUp() {
        super.setUp()
        
        let dealerGroups = [DealersGroupViewModel].random
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = dealerGroups.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        dealer = randomDealer.element as! StubDealerViewModel
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        component = CapturingDealerComponent()
        context.bind(component, toDealerSearchResultAt: indexPath)
    }
    
    func testBindTheDealerTitleOntoTheComponent() {
        XCTAssertEqual(dealer.title, component.capturedDealerTitle)
    }
    
    func testBindTheDealerSubtitleOntoTheComponent() {
        XCTAssertEqual(dealer.subtitle, component.capturedDealerSubtitle)
    }
    
    func testBindTheDealerIconPNGDataOntoTheComponent() {
        XCTAssertEqual(dealer.iconPNGData, component.capturedDealerPNGData)
    }
    
}