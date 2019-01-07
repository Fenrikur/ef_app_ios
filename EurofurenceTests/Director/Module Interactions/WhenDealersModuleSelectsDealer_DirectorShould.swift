//
//  WhenDealersModuleSelectsDealer_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealersModuleSelectsDealer_DirectorShould: XCTestCase {

    func testPushDealerDetailModuleOntoDealersNavigationControllerForSelectedDealer() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let dealersNavigationController = context.navigationController(for: context.dealersModule.stubInterface)
        let dealer = DealerIdentifier.random
        context.dealersModule.simulateDidSelectDealer(dealer)

        XCTAssertEqual(context.dealerDetailModule.stubInterface, dealersNavigationController?.topViewController)
        XCTAssertEqual(dealer, context.dealerDetailModule.capturedModel)
    }

}
